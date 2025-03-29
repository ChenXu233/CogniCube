# from fastapi import APIRouter, Depends

# from cognicube_backend.databases import get_db
# from cognicube_backend.models.emotion_record import EmotionType
# from cognicube_backend.schemas.emotion import (
#     EmotionRequest,
#     EmotionResponse,
# )

# emotion = APIRouter(prefix="/emotion")


# @emotion.post(
#     "/upload",
#     response_model=EmotionResponse,
# )
# async def emotion_post(request: EmotionRequest, db=Depends(get_db)):
#     emotion = EmotionType(
#         description=request.description,
#         emotion_name=request.emotion_name,
#         display_name=request.display_name,
#         is_primary=request.is_primary,
#     )
#     db.add(emotion)
#     db.commit()
#     db.refresh(emotion)
#     return EmotionResponse(
#         result=request.description,
#     )
