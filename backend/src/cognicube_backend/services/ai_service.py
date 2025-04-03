import json
from inspect import cleandoc
from typing import Optional

from fastapi import HTTPException
from openai import AsyncOpenAI
from sqlalchemy.orm import Session

from cognicube_backend.config import CONFIG
from cognicube_backend.models.context import UserContext
from cognicube_backend.models.conversation import Conversation
from cognicube_backend.models.emotion_record import EmotionRecord
from cognicube_backend.schemas.message import Message

from .ai.context_manager import ContextManager

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
        print(self.context_manager)
        self.context_manager.add_message("system", self.prompt)

    def get_context_manager(self) -> ContextManager:
        if (
            user_context := self.db.query(UserContext)
            .filter_by(user_id=self.user_id)
            .first()
        ):
            user_context = user_context.context_manager
        else:
            user_context = ContextManager()
            self.db.add(UserContext(user_id=self.user_id, context_manager=user_context))
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
        return await self._chat(user_message)

    async def _chat(self, user_message: str):
        """AI 聊天接口"""
        self.client = await get_ai_session()
        user_message = user_message + ""  # TODO：构建聊天提示词
        self.context_manager.add_message("user", user_message)
        response = await self.client.chat.completions.create(
            model=self.model_name,
            messages=self.get_context(),
        )
        return response

    async def emotion_quantification(self, user_message: str):
        """情感量化接口"""
        self.client = await get_ai_session()

        _user_message = cleandoc(
            """
            请根据以下用户输入，结合前面的具体聊天内容，量化其情感倾向，并给出情感倾向的量化结果。
            请按以下格式输出内容:
    "字段说明": {
        "emotion_type": {
            "description": "情绪类型名称",
            "要求": "必须严格使用快乐、悲伤、愤怒、恐惧、惊讶、厌恶、中性等",
            "类型": "string(20)"
        },
        "intensity_score": {
            "description": "情绪强度分值",
            "约束": "浮点数，范围[0.0-1.0]，保留两位小数",
            "示例": 0.85
        },
        "valence": {
            "description": "情绪效价",
            "约束": "浮点数，范围[-1.0,1.0]，-1=负面，1=正面",
            "示例": 0.72
        },
        "arousal": {
            "description": "唤醒度",
            "约束": "浮点数，范围[0.0-1.0]，0=平静，1=兴奋",
            "示例": 0.68
        },
        "dominance": {
            "description": "支配度（可选）",
            "约束": "浮点数，范围[0.0-1.0]，0=被支配，1=掌控",
            "示例": 0.12
        },
    },
    "输出示例": {
        "emotion_type": "恐惧",
        "intensity_score": 0.65,
        "valence": 0.8,
        "arousal": 0.4,
        "dominance": 0.7,
    }，请严格按以上格式输出。直接输出JSON字符串，不要输出除了JSON数据外的任何额外内容，也不要以markdown格式输出。
    以下是用户当前的输入：
            """
        )
        _user_message = _user_message + user_message
        self.context_manager.add_message("user", _user_message)
        response = await self.client.chat.completions.create(
            model=self.model_name,
            messages=self.get_context(),
        )
        text = response.choices[0].message.content
        print(text)

        if not text:
            return

        try:
            text_dict = json.loads(text)
        except json.JSONDecodeError:
            return

        emotion_record = EmotionRecord(
            user_id=self.user_id,
            emotion_type=text_dict["emotion_type"],
            intensity_score=text_dict["intensity_score"],
            valence=text_dict["valence"],
            arousal=text_dict["arousal"],
            dominance=text_dict.get("dominance", None),
        )
        self.db.add(emotion_record)
        self.db.commit()
        return emotion_record

    async def save_message_record(self, user_id: int, message: Message):
        """保存对话记录"""
        message_record = Conversation(
            user_id=user_id,
            who=message.who,
            reply_to=message.reply_to,
            message=[i.model_dump() for i in message.messages],
            extensions=message.extensions,
        )
        try:
            self.db.add(message_record)
            self.db.commit()
            return message_record
        except Exception as e:
            self.db.rollback()
            raise HTTPException(status_code=500, detail=f"消息保存失败: {str(e)}")
