from pydantic import BaseModel, Field
from typing import List


class ConversationRequest(BaseModel):
    message: str = Field(..., min_length=1, description="对话内容")


class ConversationResponse(BaseModel):
    reply: str = Field(..., description="AI生成的回复内容")


class ConversationHistoryItem(BaseModel):
    message: str
    reply: str
    timestamp: int


class ConversationHistoryResponse(BaseModel):
    history: List[ConversationHistoryItem]
