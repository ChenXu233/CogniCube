from pydantic import BaseModel, Field


class EmotionRequest(BaseModel):
    emotion_name: str = Field(..., description="Name of the emotion to be expressed")
    display_name: str = Field(..., description="Display name of the emotion")
    is_primary: bool = Field(..., description="Whether the emotion is primary or not")
    description: str = Field(..., description="Description of the emotion")


class EmotionResponse(BaseModel):
    result: str
