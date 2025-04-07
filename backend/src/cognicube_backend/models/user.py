from datetime import UTC, datetime

from sqlalchemy import Boolean, DateTime, Integer, String
from sqlalchemy.orm import Mapped, Session, mapped_column
from werkzeug.security import check_password_hash, generate_password_hash

from cognicube_backend.databases.database import Base


class User(Base):
    """数据库中的User模型"""

    __tablename__ = "users"
    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    username: Mapped[str] = mapped_column(String, unique=True, index=True)
    email: Mapped[str] = mapped_column(String, unique=True, index=True)
    password_hash: Mapped[str] = mapped_column(String)
    is_verified: Mapped[bool] = mapped_column(Boolean, default=False)
    verification_token: Mapped[str | None] = mapped_column(String, index=True)
    verification_token_expiry: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True)
    )
    is_admin: Mapped[bool] = mapped_column(Boolean, default=False)
    recent_emotion_level: Mapped[int] = mapped_column(Integer, default=0)
    created_on: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=lambda: datetime.now(UTC)
    )

    @property
    def password(self):
        """密码属性不可读"""
        raise AttributeError("password is not a readable attribute")

    @password.setter
    def password(self, password):
        self.password_hash = generate_password_hash(password)

    def verify_password(self, password):
        """验证密码"""
        return check_password_hash(self.password_hash, password)


# 用户表相关操作
def get_user(db: Session, user_id: int):
    """查询并获取用户"""
    return db.query(User).filter(User.id == user_id).first()


def create_user(
    db: Session,
    username: str,
    email: str,
    password: str,
    verification_token: str,
    token_expiry: datetime,
) -> User:
    """创建用户"""
    user = User(
        username=username,
        email=email,
        password=password,
        verification_token=verification_token,
        verification_token_expiry=token_expiry,
    )
    try:
        db.add(user)
        db.commit()
        db.refresh(user)
    except Exception as e:
        db.rollback()
        raise e
    return user
