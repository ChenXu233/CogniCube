from typing import List, Dict, Literal
from openai.types.chat import (
    ChatCompletionMessageParam,
    ChatCompletionUserMessageParam,
    ChatCompletionSystemMessageParam,
    ChatCompletionAssistantMessageParam,
)
import re

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
    en_words = re.findall(r"[a-zA-Z]+", context)
    en_word_count = len(en_words)
    en_char_count = sum(len(word) for word in en_words)
    zh_chars = re.findall(r"[\u4e00-\u9fa5]", context)
    zh_count = len(zh_chars)
    num_chars = re.findall(r"\d", context)
    num_count = len(num_chars)
    total_length = len(context)
    other_count = total_length - en_char_count - zh_count - num_count
    total = (zh_count * zh_weight) + (en_word_count * en_weight)
    total += (num_count * num_weight) + (other_count * other_weight)
    return int(total)


class ContextManager:
    def __init__(self, model: str = "DeepSeek-chat", reserved_tokens: int = 500):
        self.token_counter = token_counter
        self._message_queue = []  # 存储 user/assistant 消息的队列
        self.system_message = None  # 单独存储系统消息
        self.current_tokens = 0  # 总 Token 数（包括系统消息）
        self._setup_model_config(model, reserved_tokens)

    def _setup_model_config(self, model: str, reserved: int):
        self.model = model
        self.max_total_tokens = MODEL_CONTEXT_CONFIG.get(model, 4096)
        self.reserved_tokens = reserved
        self._max_ctx_tokens = max(0, self.max_total_tokens - self.reserved_tokens)

    def set_model(self, model: str):
        prev_max = self.max_total_tokens
        self._setup_model_config(model, self.reserved_tokens)
        if self.max_total_tokens < prev_max:
            self._enforce_token_limit()

    def add_message(self, role: Literal["assistant", "user", "system"], content: str):
        if role == "system":
            self._update_system_message(content)
        else:
            self._add_to_queue(role, content)

    def _update_system_message(self, content: str):
        # 计算系统消息的 Token
        new_token = self._calc_token("system", content)
        # 替换原有系统消息并更新 Token 计数
        if self.system_message:
            self.current_tokens -= self.system_message["tokens"]
        self.system_message = {
            "role": "system",
            "content": content,
            "tokens": new_token,
        }
        self.current_tokens += new_token
        # 添加后强制检查队列是否超限
        self._enforce_token_limit()

    def _add_to_queue(self, role: Literal["assistant", "user"], content: str):
        new_token = self._calc_token(role, content)
        # 预检查：假设系统消息存在时是否超限
        if self.current_tokens + new_token > self._max_ctx_tokens:
            raise ValueError(
                f"消息过长（需 {new_token}t，剩余 {self._max_ctx_tokens - self.current_tokens}t）"
            )
        # 加入队列并更新 Token
        self._message_queue.append(
            {"role": role, "content": content, "tokens": new_token}
        )
        self.current_tokens += new_token
        # 强制修剪队列
        self._enforce_token_limit()

    def _enforce_token_limit(self):
        """优先修剪队列中的旧消息，保留系统消息"""
        while (
            self.current_tokens > self._max_ctx_tokens and len(self._message_queue) > 0
        ):
            removed = self._message_queue.pop(0)
            self.current_tokens -= removed["tokens"]

    def get_context(self) -> List[ChatCompletionMessageParam]:
        context = []
        # 始终包含系统消息（如果存在）
        if self.system_message:
            context.append(
                ChatCompletionSystemMessageParam(
                    role="system", content=self.system_message["content"]
                )
            )
        # 添加队列中的消息
        for msg in self._message_queue:
            if msg["role"] == "user":
                context.append(ChatCompletionUserMessageParam(**msg))
            else:
                context.append(ChatCompletionAssistantMessageParam(**msg))
        return context

    def _calc_token(self, role: str, content: str) -> int:
        return token_counter(str({"role": role, "content": content}))

    def correct_token(self, token: int):
        """根据OpenAI接口返回的内容修正 token 的数量"""
        self._max_ctx_tokens = token

    def get_model_info(self) -> Dict:
        """获取当前模型信息"""
        return {"model": self.model, "context_length": self.max_total_tokens}

    def __str__(self) -> str:
        return f"ContextManager(model={self.model}, max_total_tokens={self.max_total_tokens}, reserved_tokens={self.reserved_tokens})"
