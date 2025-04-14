from typing import List

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from cognicube_backend.databases.database import get_db
from cognicube_backend.logger import logger
from cognicube_backend.models.emotion_record import EmotionRecord
from cognicube_backend.schemas.statistics import (
    EmotionLevelResponse,
    EmotionRecordResponse,
)
from cognicube_backend.services.emotion_calculate import calculate_emotion_level
from cognicube_backend.utils.jwt_generator import get_jwt_token_user_id

statistics = APIRouter(prefix="/apis/v1/statistics", tags=["statistics"])


@statistics.get("/emotion_record", response_model=List[EmotionRecordResponse])
async def get_emotion_record(
    user_id: int = Depends(get_jwt_token_user_id), db: Session = Depends(get_db)
):
    """
    Get emotion records for a user.
    """
    emotion_records = (
        db.query(EmotionRecord).filter(EmotionRecord.user_id == user_id).all()
    )

    return [
        EmotionRecordResponse(
            user_id=record.user_id,
            timestamp=int(record.time.timestamp()),
            emotion_type=record.emotion_type,
            intensity_score=record.intensity_score,
            valence_score=record.valence,
            arousal_score=record.arousal,
            dominance_score=record.dominance,
        )
        for record in emotion_records
    ]


@statistics.get("/emotion_weather", response_model=EmotionLevelResponse)
async def get_user_emotion_level(
    user_id: int = Depends(get_jwt_token_user_id), db: Session = Depends(get_db)
):
    """
    Get emotion level for a user.
    """
    emotion_records = (
        db.query(EmotionRecord)
        .filter(EmotionRecord.user_id == user_id)
        .order_by(EmotionRecord.time.desc())
        .limit(100)
        .all()
    )

    emotion_type, emotion_level = calculate_emotion_level(emotion_records)

    return EmotionLevelResponse(
        emotion_type=emotion_type,
        emotion_level=emotion_level,
    )
