from fastapi import HTTPException
from cognicube_backend.models.conversation import Conversation, Who
from sqlalchemy.orm import Session
from sqlalchemy.orm import Session
from cognicube_backend.models.conversation import Conversation, Who
from cognicube_backend.utils.get_ai_session import ai_chat_api  

async def save_message_record(db: Session, user_id: int, user_message: str, who: str, reply_to: int = None):
    """简化保存对话记录的过程"""
    message_record = Conversation(
        user_id=user_id,
        message=user_message,  
        who=who,
        reply_to=reply_to,
    )
    try:
        db.add(message_record)
        db.commit()
        # db.refresh(message_record)
        return message_record
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"消息保存失败: {str(e)}")

async def create_conversation_record(db: Session, user_id: int, user_message: str, deepseek_function):
    """创建对话记录，先保存提问，再保存回答"""
    try:
        user_message_record = await save_message_record(db, user_id, user_message, Who.USER)
        ai_reply = await ai_chat_api(user_message)
        await save_message_record(db, user_id, ai_reply, Who.AI, reply_to=user_message_record.message_id)
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"对话记录保存失败: {str(e)}")

