from pydantic import BaseModel
from typing import List

class Message(BaseModel):
    text: str
    reply_to: str
    timestamp: int
    who: str
    message_id: int

class ConversationHistoryResponse(BaseModel):
    history: List[Message]