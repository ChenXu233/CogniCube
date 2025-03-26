from typing import List, Dict, Literal, Optional
from openai.types.chat import ChatCompletionMessageParam
import re

# 模型上下文长度配置表（单位：tokens）
MODEL_CONTEXT_CONFIG = {
    "DeepSeek-chat": 56 * 1000,
    "DeepSeek-R1": 120 * 1000,
}


def token_counter(
    context: str,
    zh_weight: float = 0.6,
    en_weight: float = 0.3,
    num_weight: int = 1,
    other_weight: int = 1,
) -> int:
    # 统计英文单词及其占用字符总数
    en_words = re.findall(r"[a-zA-Z]+", context)
    en_word_count = len(en_words)
    en_char_count = sum(len(word) for word in en_words)

    # 统计中文字符数量
    zh_chars = re.findall(r"[\u4e00-\u9fa5]", context)
    zh_count = len(zh_chars)

    # 统计数字字符数量
    num_chars = re.findall(r"\d", context)
    num_count = len(num_chars)

    # 计算其他字符数量
    total_length = len(context)
    other_count = total_length - en_char_count - zh_count - num_count

    # 加权求和
    total = (zh_count * zh_weight) + (en_word_count * en_weight)
    total += (num_count * num_weight) + (other_count * other_weight)

    return int(total)


class ContextManager:
    def __init__(self, model: str = "DeepSeek-R1", reserved_tokens: int = 500):
        """
        Args:
            model: 使用的模型名称，默认为 "DeepSeek-R1"
            reserved_tokens: 为 AI 生成预留的空间（默认 500）
        """
        self.token_counter = token_counter
        self._message_stack = []
        self.current_tokens = 0
        self._setup_model_config(model, reserved_tokens)

    def _setup_model_config(self, model: str, reserved: int):
        """初始化模型配置"""
        self.model = model
        self.max_total_tokens = MODEL_CONTEXT_CONFIG.get(model, 4096)
        self.reserved_tokens = reserved
        self._max_ctx_tokens = max(0, self.max_total_tokens - self.reserved_tokens)

    def set_model(self, model: str):
        """切换模型（保留现有消息并自动修剪）"""
        prev_max = self.max_total_tokens
        self._setup_model_config(model, self.reserved_tokens)

        # 仅在新模型上下文更小时触发自动修剪
        if self.max_total_tokens < prev_max:
            self._enforce_token_limit()

    def add_message(self, role: Literal["assistant", "user"], content: str):
        """添加消息并自动维护 token 限制"""
        token_cost = self._calc_token(role, content)

        if token_cost > self._max_ctx_tokens:
            raise ValueError(
                f"消息过长 (需要 {token_cost}t，可用 {self._max_ctx_tokens}t)"
            )

        self._message_stack.append(
            {"role": role, "content": content, "tokens": token_cost}
        )
        self.current_tokens += token_cost
        self._enforce_token_limit()

    def get_context(self, reserved_tokens: Optional[int] = None) -> List[Dict]:
        """动态调整预留空间的上下文"""
        reserved = reserved_tokens or self.reserved_tokens
        temp_max_ctx = max(0, self.max_total_tokens - reserved)

        temp_stack = self._message_stack.copy()
        current_temp_tokens = sum(msg["tokens"] for msg in temp_stack)

        while current_temp_tokens > temp_max_ctx and temp_stack:
            removed = temp_stack.pop(0)
            current_temp_tokens -= removed["tokens"]

        return [{"role": m["role"], "content": m["content"]} for m in temp_stack]

    def _calc_token(self, role: str, content: str) -> int:
        """通过 LangChain 计算完整消息 token"""
        message = {"role": role, "content": content}
        return self.token_counter(str(message))

    def _enforce_token_limit(self):
        """强制 token 限制"""
        while self.current_tokens > self._max_ctx_tokens and self._message_stack:
            removed = self._message_stack.pop(0)
            self.current_tokens -= removed["tokens"]

    def correct_token(self, token: int):
        """根据OpenAI接口返回的内容修正 token 的数量"""
        self._max_ctx_tokens = token

    def get_model_info(self) -> Dict:
        """获取当前模型信息"""
        return {"model": self.model, "context_length": self.max_total_tokens}
