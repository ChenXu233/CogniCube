from datetime import UTC, datetime
from typing import Optional

from sqlalchemy import CheckConstraint, DateTime, Integer, String
from sqlalchemy.orm import Mapped, mapped_column, validates

from cognicube_backend.databases.database import Base


class EmotionRecord(Base):
    __tablename__ = "emotion_records"

    record_id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    user_id: Mapped[int] = mapped_column(Integer, index=True)
    time: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=lambda: datetime.now(UTC)
    )

    emotion_type: Mapped[str] = mapped_column(String(50))

    intensity_score: Mapped[float] = mapped_column(
        CheckConstraint("intensity_score BETWEEN 0 AND 1")
    )
    valence: Mapped[float] = mapped_column(CheckConstraint("valence BETWEEN -1 AND 1"))
    arousal: Mapped[float] = mapped_column(CheckConstraint("arousal BETWEEN 0 AND 1"))
    dominance: Mapped[Optional[float]] = mapped_column(
        CheckConstraint("dominance BETWEEN 0 AND 1")
    )

    @validates("valence", "arousal", "dominance")
    def validate_scores(self, key: str, value: float) -> float:
        if key == "valence" and not (-1 <= value <= 1):
            raise ValueError("Valence must be between -1 and 1")
        if key in ("arousal", "dominance") and not (0 <= value <= 1):
            raise ValueError(f"{key} must be between 0 and 1")
        return value

    def __repr__(self) -> str:
        return f"<EmotionRecord {self.emotion_type} (user={self.user_id})>"
