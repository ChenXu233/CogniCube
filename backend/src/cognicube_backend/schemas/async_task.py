from pydantic import BaseModel
from typing import Dict, Any

from cognicube_backend.schemas.conversation import ConversationResponse

"""
    AsyncTaskCreate,
    AsyncTaskResponse,
    TaskStatusResponse,
"""


class AsyncTaskCreate(BaseModel):
    task_name: str
    task_type: str
    task_data: Dict[str, Any]


class AsyncTaskResponse(BaseModel):
    task_id: str
    check_interval: int
    status_url: str
    status: str


class TaskStatusResponse(BaseModel):
    status: str
    result: ConversationResponse
    created_at: int
    updated_at: int | None
