from datetime import UTC, datetime
from enum import Enum
from typing import Any, List, Optional

from sqlalchemy import JSON, DateTime
from sqlalchemy import Enum as SQLEnum
from sqlalchemy import ForeignKey, Integer, String
from sqlalchemy.orm import Mapped, mapped_column

from cognicube_backend.databases.database import Base
from cognicube_backend.schemas.message import Expression, Text


class Who(str, Enum):
    USER = "user"
    AI = "assistant"
    SYSTEM = "system"


class Conversation(Base):
    """数据库中的聊天记录模型"""

    __tablename__ = "conversations"
    who: Mapped[Who] = mapped_column(SQLEnum(Who))
    time: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=lambda: datetime.now(UTC)
    )
    reply_to: Mapped[Optional[int]] = mapped_column(
        Integer, ForeignKey("conversations.message_id")
    )
    user_id: Mapped[int] = mapped_column(Integer, ForeignKey("users.id"), index=True)
    message: Mapped[List[Text | Expression]] = mapped_column(JSON)
    message_id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    extensions: Mapped[dict[str, Any]] = mapped_column(JSON)
