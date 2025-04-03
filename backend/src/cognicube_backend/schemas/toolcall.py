from typing import Any, Dict

from pydantic import BaseModel


class ToolCallRequest(BaseModel):
    call_id: str
    name: str
    arguments: Dict[str, Any]


class ToolCallResponse(BaseModel):
    call_id: str
    content: str
    status: str = "success"
