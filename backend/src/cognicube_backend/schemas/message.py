from pydantic import BaseModel
from typing import List
from cognicube_backend.models.conversation import Conversation
from abc import ABC, abstractmethod

class Message(BaseModel,ABC):
    text: str
    reply_to: int | None = None
    timestamp: float | None = None
    who: str
    message_id: int | None = None


class ConversationHistoryResponse(BaseModel):
    history: List[Message]
