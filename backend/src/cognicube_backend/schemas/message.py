from abc import ABC
from enum import Enum
from typing import Any, Dict, List

from pydantic import BaseModel


class MessageType(Enum):
    TEXT = "text"
    EXPRESSION = "expression"


class Text(BaseModel):
    type: str = MessageType.TEXT.value
    text: str


class Expression(BaseModel):
    type: str = MessageType.EXPRESSION.value
    expression_id: int
    text: str


class Message(BaseModel, ABC):
    messages: List[Text | Expression]
    reply_to: int | None = None
    timestamp: float | None = None
    who: str
    message_id: int | None = None
    extensions: Dict[str, Any] = {}

    def get_plain_text(self) -> str:
        temp = ""
        for i in self.messages:
            match i.type:
                case MessageType.TEXT.value:
                    temp += i.text
                case MessageType.EXPRESSION.value:
                    temp += f"[[图片]({i.text})]"
        return temp

    def to_orm_model(self):
        pass

    def to_dict(self):
        return self.model_dump()
