from pydantic import BaseModel
from typing import List

class ConversationHistoryItem(BaseModel):
    message: str
    reply: str
    timestamp: int


class ConversationHistoryResponse(BaseModel):
    history: List[ConversationHistoryItem]