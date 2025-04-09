import re
from typing import Any, Dict, List, Literal, Optional

from openai.types.chat import (
    ChatCompletionAssistantMessageParam,
    ChatCompletionMessageParam,
    ChatCompletionSystemMessageParam,
    ChatCompletionUserMessageParam,
)
from sqlalchemy import JSON, Integer, String, Text
from sqlalchemy.ext.mutable import MutableList
from sqlalchemy.orm import Mapped, mapped_column

from cognicube_backend.databases.database import Base

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


class UserContext(Base):
    """用户上下文表，直接集成 ContextManager 功能"""

    __tablename__ = "user_contexts"

    user_id: Mapped[int] = mapped_column(Integer, primary_key=True)
    model: Mapped[str] = mapped_column(String(50), default="DeepSeek-chat")
    reserved_tokens: Mapped[int] = mapped_column(Integer, default=500)
    system_content: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    system_tokens: Mapped[int] = mapped_column(Integer, default=0)
    message_queue: Mapped[List[Dict[str, Any]]] = mapped_column(
        MutableList.as_mutable(JSON), default=[]
    )
    current_tokens: Mapped[int] = mapped_column(Integer, default=0)

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        if self.reserved_tokens is None:
            self.reserved_tokens = 500
        if self.current_tokens is None:
            self.current_tokens = 0
        if self.system_tokens is None:
            self.system_tokens = 0

    @property
    def max_total_tokens(self) -> int:
        return MODEL_CONTEXT_CONFIG.get(self.model, 4096)

    @property
    def _max_ctx_tokens(self) -> int:
        return max(0, self.max_total_tokens - self.reserved_tokens)

    def set_model(self, model: str):
        prev_max = self.max_total_tokens
        self.model = model
        if self.max_total_tokens < prev_max:
            self._enforce_token_limit()

    def add_message(self, role: Literal["assistant", "user", "system"], content: str):
        if role == "system":
            self._update_system_message(content)
        else:
            self._add_to_queue(role, content)

    def _update_system_message(self, content: str):
        new_token = self._calc_token("system", content)
        if self.system_content is not None:
            self.current_tokens = (self.current_tokens or 0) - (self.system_tokens or 0)
        self.system_content = content
        self.system_tokens = new_token
        self.current_tokens += new_token
        self._enforce_token_limit()

    def _add_to_queue(self, role: Literal["assistant", "user"], content: str):
        new_token = self._calc_token(role, content)
        if self.current_tokens + new_token > self._max_ctx_tokens:
            raise ValueError(
                f"消息过长（需 {new_token}t，剩余 {self._max_ctx_tokens - self.current_tokens}t）"
            )
        self.message_queue.append(
            {"role": role, "content": content, "tokens": new_token}
        )
        self.current_tokens += new_token
        self._enforce_token_limit()

    def _enforce_token_limit(self):
        while (
            self.current_tokens > self._max_ctx_tokens and len(self.message_queue) > 0
        ):
            removed = self.message_queue.pop(0)
            self.current_tokens -= removed["tokens"]

    def get_context(self) -> List[ChatCompletionMessageParam]:
        context = []
        if self.system_content is not None:
            context.append(
                ChatCompletionSystemMessageParam(
                    role="system", content=self.system_content
                )
            )
        for msg in self.message_queue:
            if msg["role"] == "user":
                context.append(ChatCompletionUserMessageParam(**msg))
            else:
                context.append(ChatCompletionAssistantMessageParam(**msg))
        return context

    def _calc_token(self, role: str, content: str) -> int:
        return token_counter(str({"role": role, "content": content}))

    def correct_token(self, token: int):
        self.reserved_tokens = self.max_total_tokens - token

    def get_model_info(self) -> Dict:
        return {"model": self.model, "context_length": self.max_total_tokens}

    def __repr__(self) -> str:
        return (
            f"UserContext(user_id={self.user_id}, model='{self.model}', "
            f"reserved_tokens={self.reserved_tokens}, current_tokens={self.current_tokens})"
        )
