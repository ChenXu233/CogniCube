from sqlalchemy.orm import declarative_base, Mapped, mapped_column
from sqlalchemy import Column, String, Integer, ForeignKey, JSON, Text, DateTime
from sqlalchemy import Enum as SAEnum
from datetime import datetime
from enum import Enum

from cognicube_backend.schemas.conversation import ConversationResponse

Base = declarative_base()


class TaskStatus(str, Enum):
    PENDING = "pending"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    FAILED = "failed"


class AsyncTask(Base):
    __tablename__ = "async_tasks"

    task_id: Mapped[str] = mapped_column(
        Column(String(36), primary_key=True, index=True)
    )
    user_id: Mapped[int] = mapped_column(Column(Integer, ForeignKey("users.id")))
    status: Mapped[TaskStatus] = mapped_column(
        Column(SAEnum(TaskStatus), default=TaskStatus.PENDING)
    )
    request_data: Mapped[dict] = mapped_column(Column(JSON))  # 原始请求数据
    result_data: Mapped[dict] = mapped_column(Column(JSON))  # 处理结果数据
    error_info: Mapped[str] = mapped_column(Column(Text))  # 错误信息
    created_at: Mapped[datetime] = mapped_column(Column(DateTime, default=datetime.now))
    updated_at: Mapped[datetime] = mapped_column(Column(DateTime))
