from openai import AsyncOpenAI
from typing import Optional
from fastapi import HTTPException
from sqlalchemy.orm import Session


from .ai.context_manager import ContextManager
from cognicube_backend.models.conversation import Conversation, Who
from cognicube_backend.models.context import UserContext
from cognicube_backend.schemas.message import Message
from cognicube_backend.config import CONFIG

SESSION: Optional[AsyncOpenAI] = None


async def get_ai_session() -> AsyncOpenAI:
    """返回一个全局的 AsyncOpenAI 实例"""
    global SESSION
    if SESSION is None:
        SESSION = AsyncOpenAI(api_key=CONFIG.AI_API_KEY, base_url=CONFIG.AI_API_URL)
    return SESSION


class AIChatService:
    def __init__(self, user_id: int, db: Session):
        self.user_id = user_id
        self.db = db
        self.model_name = CONFIG.AI_MODEL_NAME
        self.api_key = CONFIG.AI_API_KEY
        self.api_base = CONFIG.AI_API_URL
        self.prompt = CONFIG.AI_PROMPT
        self.client: AsyncOpenAI | None = None
        self.context_manager: ContextManager = self.get_context_manager()

    def get_context_manager(self) -> ContextManager:
        if (
            user_context := self.db.query(UserContext)
            .filter_by(user_id=self.user_id)
            .first()
        ):
            pass
        else:
            user_context = ContextManager()
            self.db.add(
                UserContext(user_id=self.user_id, context_manager=self.context_manager)
            )
        return user_context

    def update_context_manager(self):
        user_context = (
            self.db.query(UserContext).filter_by(user_id=self.user_id).first()
        )
        if not self.context_manager:
            raise Exception("Context manager is not initialized")
        if not user_context:
            raise Exception("user context is not initialized")
        user_context.context_manager = self.context_manager
        self.db.commit()

    def get_context(self):
        """获取上下文"""

        return self.context_manager.get_context()

    async def chat(self, user_message: str):
        """AI 聊天接口"""
        self.client = await get_ai_session()
        self.context_manager.add_message("user", user_message)
        response = await self.client.chat.completions.create(
            model=self.model_name,
            messages=self.get_context(),
        )
        return response

    async def save_message_record(self, user_id: int, message: Message):
        """保存对话记录"""
        message_record = Conversation(
            user_id=user_id,
            who=message.who,
            reply_to=message.reply_to,
            message=[i.model_dump() for i in message.messages],
            extensions=message.extensions,
            plain_text=message.plain_text,
        )
        try:
            self.db.add(message_record)
            self.db.commit()
            return message_record
        except Exception as e:
            self.db.rollback()
            raise HTTPException(status_code=500, detail=f"消息保存失败: {str(e)}")
