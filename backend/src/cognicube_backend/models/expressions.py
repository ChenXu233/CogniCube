from sqlalchemy import (
    String,
    ForeignKey,
)
from sqlalchemy.orm import (
    Mapped,
    mapped_column,
)
from cognicube_backend.databases.database import Base


class Expression(Base):
    """表情库表"""

    __tablename__ = "expressions"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    base64: Mapped[str] = mapped_column(String(200))
    description: Mapped[str] = mapped_column(String(200))
    application_emotion_type: Mapped[str] = mapped_column(
        String(20), ForeignKey("emotion_types.emotion_name")
    )
