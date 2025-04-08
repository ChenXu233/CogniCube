from sqlalchemy import Integer, PickleType
from sqlalchemy.orm import Mapped, mapped_column

from cognicube_backend.databases.database import Base
from cognicube_backend.services.ai_services.context_manager import \
    ContextManager


class UserContext(Base):
    """用户上下文表"""

    __tablename__ = "user_contexts"

    user_id: Mapped[int] = mapped_column(Integer, primary_key=True)
    context_manager: Mapped[ContextManager] = mapped_column(
        PickleType, comment="用户对话上下文对象"
    )
