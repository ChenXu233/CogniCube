from pydantic import BaseModel, Field
from cognicube_backend.schemas.message import Message


class ConversationRequest(BaseModel):
    text: str = Field(..., min_length=1, description="对话内容")
    reply_to: int|None = Field(None, description="回复的消息ID")


class ConversationResponse(BaseModel):
    message: Message = Field(..., description="AI生成的回复内容")
