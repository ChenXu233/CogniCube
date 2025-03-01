from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
import datetime

from cognicube_backend.databases.database import get_db
from cognicube_backend.models.user import User
from cognicube_backend.models.conversation import Conversation, Who
from cognicube_backend.services.ai_service import (
    AIChatService,
)
from cognicube_backend.schemas.message import Message
from cognicube_backend.utils.jwt_generator import get_jwt_token_user_id
from cognicube_backend.schemas.conversation import (
    ConversationRequest,
    ConversationResponse,
)

ai = APIRouter(prefix="/apis/v1/ai")


@ai.post("/conversation", response_model=ConversationResponse)
async def create_conversation(
    text: ConversationRequest,
    user_id: int = Depends(get_jwt_token_user_id),
    db: Session = Depends(get_db),
):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="用户不存在")

    _message = Message(text=text.text, who="USER")

    ai_service = AIChatService(db)
    await ai_service.save_message_record(user_id, _message)
    ai_response = await ai_service.chat(user_id, text.text)
    ai_response_text: str = ai_response.choices[0].message.content  # type: ignore
    await ai_service.save_ai_message_record(user_id=user_id, text=ai_response_text)
    
    _ai_message = db.query(Conversation).filter(Conversation.user_id == user_id).filter(Conversation.who == Who.AI).order_by(Conversation.time.desc()).first()
    if not _ai_message:
        raise HTTPException(status_code=404, detail="AI回复不存在")
    ai_message = Message(
        text=ai_response_text,
        who="AI",
        reply_to=_ai_message.reply_to,
        timestamp= _ai_message.time.timestamp(),
        message_id=_ai_message.message_id,
        )
    return ConversationResponse(message=ai_message)


@ai.get("/history")
async def get_conversation_history(
    # token: str = Query(..., description="用户的JWT访问令牌"),
    start_time: int = Query(..., description="起始时间戳（包含）"),
    end_time: int = Query(..., description="结束时间戳（包含）"),
    user_id: int = Depends(get_jwt_token_user_id),
    db: Session = Depends(get_db),
):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="用户不存在")

    # 将时间戳转换为 datetime 对象
    start_datetime = datetime.datetime.fromtimestamp(start_time)
    end_datetime = datetime.datetime.fromtimestamp(end_time)

    # 查询符合时间范围的对话记录
    conversations = (
        db.query(Conversation)
        .filter(
            Conversation.user_id == user_id,
            Conversation.time >= start_datetime,
            Conversation.time <= end_datetime,
        )
        .order_by(Conversation.time)
        .all()
    )

    # 构造返回数据
    history = [
        Message(
            text=convo.text,
            who=convo.who,
            reply_to=convo.reply_to,
            timestamp=convo.time.timestamp(),
            message_id=convo.message_id,
        ) for convo in conversations
    ]

    return {"history": history}
