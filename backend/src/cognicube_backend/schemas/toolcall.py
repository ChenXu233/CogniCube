from pydantic import BaseModel
from typing import Dict, Any


class ToolCallRequest(BaseModel):
    call_id: str
    name: str
    arguments: Dict[str, Any]


class ToolCallResponse(BaseModel):
    call_id: str
    content: str
    status: str = "success"
