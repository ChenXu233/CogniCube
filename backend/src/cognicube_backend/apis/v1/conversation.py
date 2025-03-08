from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
import datetime

from cognicube_backend.databases.database import get_db
from cognicube_backend.models.user import User
from cognicube_backend.models.conversation import Conversation, Who
from cognicube_backend.services.ai_service import (
    AIChatService,
)
from cognicube_backend.schemas.message import Message,Text
from cognicube_backend.utils.jwt_generator import get_jwt_token_user_id
from cognicube_backend.schemas.conversation import (
    ConversationRequest,
    ConversationResponse,
)
from cognicube_backend.utils.decorator import verify_email_verified

ai = APIRouter(prefix="/apis/v1/ai")


@ai.post("/conversation", response_model=ConversationResponse)
@verify_email_verified(get_db)
async def create_conversation(
    message: ConversationRequest,
    user_id: int = Depends(get_jwt_token_user_id),
    db: Session = Depends(get_db),
):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="用户不存在")

    ai_service = AIChatService(db)
    await ai_service.save_message_record(user_id, message.message)
    ai_response = await ai_service.chat(user_id, message.message.plain_text)
    ai_response_text: str = ai_response.choices[0].message.content  # type: ignore
    ai_message = Message(
        plain_text=ai_response_text,
        message_type="text",
        who=Who.AI.value,
        message=[Text(content=ai_response_text)],
    )
    await ai_service.save_message_record(user_id, ai_message)
    
    _ai_message = db.query(Conversation).filter(Conversation.user_id == user_id).filter(Conversation.who == Who.AI.value).order_by(Conversation.time.desc()).first()
    if not _ai_message:
        raise HTTPException(status_code=404, detail="AI回复不存在")

    return ConversationResponse(message=ai_message)


@ai.get("/history")
@verify_email_verified(get_db)
async def get_conversation_history(
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
            message=convo.message,
            plain_text=convo.plain_text,
            who=convo.who.value,
            message_type=convo.message_type,
            message_id=convo.message_id,
            timestamp=convo.time.timestamp(),
            extensions=convo.extensions,
            reply_to=convo.reply_to,
        ) for convo in conversations
    ]

    return {"history": history}
