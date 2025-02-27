from fastapi import HTTPException
from cognicube_backend.models.conversation import Conversation, Who
from sqlalchemy.orm import Session
import aiohttp
from fastapi import status
from cognicube_backend.config import CONFIG
from typing import Optional


SESSION: Optional[aiohttp.ClientSession] = None

async def get_ai_session() -> aiohttp.ClientSession:
    """返回一个全局的 aiohttp.ClientSession 实例"""
    global SESSION
    if SESSION is None:
        SESSION = aiohttp.ClientSession()
    return SESSION

async def ai_chat_api(user_message: str) -> str:
    """调用 AI 聊天接口"""
    session = await get_ai_session()
    try:
        async with session.post(
            CONFIG.AI_API_URL,
            headers={
                "Authorization": f"Bearer {CONFIG.AI_API_KEY}",
                "Content-Type": "application/json",
            },
            json={
                "messages": [{"role": "user", "content": user_message}],
                "model": "deepseek-ai/DeepSeek-V3",
                "temperature": 0.7,
            },
        ) as response:
            response.raise_for_status()
            data = await response.json()
            return data["choices"][0]["message"]["content"]
    except aiohttp.ClientError as e:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail=f"AI服务请求失败: {str(e)}",
        )


async def save_message_record(db: Session, user_id: int, user_message: str, who: str, reply_to: int|None = None):
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
        return message_record
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"消息保存失败: {str(e)}")

async def create_conversation_record(db: Session, user_id: int, user_message: str):
    """创建对话记录，先保存提问，再保存回答"""
    try:
        user_message_record = await save_message_record(db, user_id, user_message, Who.USER)
        ai_reply = await ai_chat_api(user_message)
        await save_message_record(db, user_id, ai_reply, Who.AI, reply_to=user_message_record.message_id)
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"对话记录保存失败: {str(e)}")
    
    
class AIChatService:
    def __init__(self, db: Session):
        self.db = db

    async def save_message_record(self, user_id: int, user_message: str, who: str, reply_to: int = None):
        """简化保存对话记录的过程"""
        message_record = Conversation(
            user_id=user_id,
            message=user_message,  
            who=who,
            reply_to=reply_to,
        )
        try:
            self.db.add(message_record)
            self.db.commit()
            # self.db.refresh(message_record)
            return message_record
        except Exception as e:
            self.db.rollback()
            raise HTTPException(status_code=500, detail=f"消息保存失败: {str(e)}")

    async def create_conversation_record(self, user_id: int, user_message: str):
        """创建对话记录，先保存提问，再保存回答"""
        try:
            user_message_record = await self.save_message_record(user_id, user_message, Who.USER.value)
            ai_reply = await ai_chat_api(user_message)
            await self.save_message_record(user_id, ai_reply, Who.AI, reply_to=user_message_record.message_id)
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"对话记录保存失败: {str(e)}")
        
class AIContext:
    """
    AI的上下文类
    """

    def __init__(self):
        self.contents = {}

    def _get_target_dict(self, is_private):
        return self.contents["private"] if is_private else self.contents["non-private"]

    def append(self, content, target_id: str, is_private: bool):
        """
        往上下文中添加消息
        """
        target_dict = self._get_target_dict(is_private)
        target_dict.setdefault(target_id, []).append(content)

    def set_context(self, contexts, target_id: str, is_private: bool):
        """
        设置上下文
        """
        self._get_target_dict(is_private)[target_id] = contexts

    def reset(self, target_id: str, is_private: bool):
        """
        重置上下文
        """
        self._get_target_dict(is_private).pop(target_id, None)

    def reset_all(self):
        """
        重置所有上下文
        """
        self.contents = {"private": {}, "non-private": {}}

    def build(self, target_id: str, is_private: bool) -> list:
        """
        构建返回的上下文，不包括系统消息
        """
        return self._get_target_dict(is_private).setdefault(target_id, [])