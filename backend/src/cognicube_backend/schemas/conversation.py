from typing import List

from pydantic import BaseModel, Field

from cognicube_backend.schemas.message import Message


class ConversationRequest(BaseModel):
    message: Message = Field(..., description="用户输入的内容")


class ConversationResponse(BaseModel):
    message: Message = Field(..., description="AI生成的回复内容")


class ConversationHistoryResponse(BaseModel):
    history: List[Message]
