from pydantic import BaseModel


class EmotionRecordResponse(BaseModel):
    """情感记录响应"""

    timestamp: int
    emotion_type: str
    intensity_score: float
    valence_score: float
    arousal_score: float
    dominance_score: float
    user_id: int


class EmotionLevelResponse(BaseModel):
    """情感等级响应"""

    emotion_level: float
    emotion_type: str
