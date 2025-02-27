from openai import AsyncOpenAI
from typing import Optional
from fastapi import HTTPException, status
from sqlalchemy.orm import Session

from cognicube_backend.models.conversation import Conversation, Who
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
    def __init__(self, db: Session):
        self.db = db
        self.SESSION = get_ai_session()
        self.model_name = 'deepseek-chat'
        self.api_key = CONFIG.AI_API_KEY
        self.api_base = CONFIG.AI_API_URL
        self.prompt = CONFIG.AI_PROMPT
        self.client:AsyncOpenAI|None = None                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
        self.history = []
    
    def build_history(self, user_id: int):
        """构建历史对话记录"""
        records = self.db.query(Conversation).filter_by(user_id=user_id).order_by(Conversation.message_id.desc()).limit(50).all()
        
        for record in records:
            self.history.append({"role": "user" if record.who == Who.USER else "assistant", "content": record.text})
        return self.history
    
    async def chat(self, user_id: int, user_message: str):
        """AI 聊天接口"""
        self.client = await get_ai_session()
        self.build_history(user_id)
        self.history.extend([{"content": user_message, "role": "user"}])
        response = await self.client.chat.completions.create(model=self.model_name, messages=self.history)
        return response

    async def save_message_record(self, user_id: int, message: Message):
        """简化保存对话记录的过程"""
        message_record = Conversation(
            user_id=user_id,
            text=message.text,  
            who=message.who,
            reply_to=message.reply_to,
        )
        try:
            self.db.add(message_record)
            self.db.commit()
            return message_record
        except Exception as e:
            self.db.rollback()
            raise HTTPException(status_code=500, detail=f"消息保存失败: {str(e)}")
    
    async def save_ai_message_record(self, user_id: int, text: str, reply_to: int|None = None):
        """简化保存 AI 对话记录的过程"""
        message = Message(text=text, who=str(Who.AI), reply_to=reply_to,timestamp=None,message_id=None)
        return await self.save_message_record(user_id, message)