from pydantic import BaseModel, Field


class ExpressionRequest(BaseModel):
    description: str = Field(..., description="The expression to evaluate")
    base64: str = Field(..., description="The base64 encoded expression")
    application_emotion_type: str = Field(
        ..., description="The application emotion type"
    )


class ExpressionResponse(BaseModel):
    result: str = Field(..., description="The result of the expression evaluation")
