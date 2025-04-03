"""
@Description :   用户的Pydantic 模型（用于请求/响应）
"""

import re
from datetime import datetime

from pydantic import BaseModel, field_validator


class UserCreate(BaseModel):
    """用户创建模型,用于注册时的请求"""

    username: str
    email: str
    password: str

    @field_validator("username")
    @classmethod
    def validate_username(cls, value):
        """验证用户名合法性"""
        if not (3 < len(value) < 20):
            raise ValueError(
                "Username must be at least 3 characters long and at most 20 characters long"
            )
        if not value.isalnum():
            raise ValueError("Username must contain only alphanumeric characters")
        return value

    @field_validator("email")
    @classmethod
    def validate_email(cls, value):
        """验证邮箱格式"""
        if re.match(r"[^@]+@[^@]+\.[^@]+", value) is None:
            raise ValueError("Invalid email format")
        return value

    @field_validator("password")
    @classmethod
    def validate_password(cls, value):
        """验证密码强度"""
        if len(value) < 6:
            raise ValueError("Password must be at least 6 characters long")
        if re.search(r"[a-zA-Z]", value) is None:
            raise ValueError("Password must contain at least one letter")
        if re.search(r"[0-9]", value) is None:
            raise ValueError("Password must contain at least one digit")
        return value


class UserLogin(BaseModel):
    """用户登录模型"""

    username: str
    password: str


class UserResponse(BaseModel):
    """用户响应模型"""

    id: int
    username: str
    email: str
    created_on: datetime
    is_verified: bool

    class Config:
        from_attributes = True


class TokenResponse(BaseModel):
    """Token响应模型"""

    access_token: str
    user_id: int
