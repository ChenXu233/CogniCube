from pydantic import BaseModel
from typing import List


class Message(BaseModel):
    text: str
    reply_to: int | None = None
    timestamp: int | None = None
    who: str
    message_id: int | None = None


class ConversationHistoryResponse(BaseModel):
    history: List[Message]
