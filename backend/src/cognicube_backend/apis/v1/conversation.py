from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
import datetime

from cognicube_backend.databases.database import get_db
from cognicube_backend.models.user import (
    User,
    Conversation,
)
from cognicube_backend.services.ai_chat import ai_chat_api, create_conversation_record
from cognicube_backend.utils.jwt_generator import get_jwt_token_user_id
from cognicube_backend.schemas.conversation import (
    ConversationRequest,
    ConversationResponse,
    ConversationHistoryResponse,
)

ai = APIRouter(prefix="/apis/v1/ai")


@ai.post("/conversation", response_model=ConversationResponse)
async def create_conversation(
    message: ConversationRequest,
    user_id: int = Depends(get_jwt_token_user_id),
    db: Session = Depends(get_db),
):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="用户不存在")

    ai_response = await ai_chat_api(message.message)
    create_conversation_record(db, user_id, message.message, ai_response)
    return {"reply": ai_response}

@ai.get("/history", response_model=ConversationHistoryResponse)
async def get_conversation_history(
    token: str = Query(..., description="用户的JWT访问令牌"),
    start_time: int = Query(..., description="起始时间戳（包含）"),
    end_time: int = Query(..., description="结束时间戳（包含）"),
    user_id: int = Depends(get_jwt_token_user_id),
    db: Session = Depends(get_db),
):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="用户不存在")

    # 将时间戳转换为 datetime 对象
    start_datetime = datetime.fromtimestamp(start_time)
    end_datetime = datetime.fromtimestamp(end_time)

    # 查询符合时间范围的对话记录
    conversations = (
        db.query(Conversation)
        .filter(
            Conversation.user_id == user_id,
            Conversation.timestamp >= start_datetime,
            Conversation.timestamp <= end_datetime,
        )
        .order_by(Conversation.timestamp)
        .all()
    )

    # 构造返回数据
    history = [
        {"message": convo.message, "timestamp": int(convo.timestamp.timestamp())}
        for convo in conversations
    ]
    
    return {"history": history}
