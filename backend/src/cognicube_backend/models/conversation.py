from datetime import datetime, UTC
from enum import Enum
from sqlalchemy import Integer, String, DateTime, ForeignKey, Enum as SQLEnum
from sqlalchemy.orm import mapped_column, Mapped
from typing import Optional
from cognicube_backend.databases.database import Base


class Who(Enum):
    USER = "User"
    AI = "AI"


class Conversation(Base):
    """数据库中的聊天记录模型"""

    __tablename__ = "conversations"
    message_id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(Integer, index=True)
    text: Mapped[str] = mapped_column(String)
    who: Mapped[Who] = mapped_column(SQLEnum(Who))
    time: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=lambda: datetime.now(UTC)
    )
    reply_to: Mapped[Optional[int]] = mapped_column(
        Integer, ForeignKey("conversations.message_id")
    )