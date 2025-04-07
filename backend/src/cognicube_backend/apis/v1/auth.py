from datetime import timedelta

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from cognicube_backend.databases.database import get_db
from cognicube_backend.logger import logger
from cognicube_backend.models.user import User
from cognicube_backend.schemas.user import TokenResponse, UserLogin
from cognicube_backend.utils.jwt_generator import (create_jwt_token,
                                                   get_jwt_token_user_id)

auth = APIRouter(prefix="/apis/v1/auth", tags=["auth"])


@auth.post("/login", response_model=TokenResponse)
async def login(user: UserLogin, db: Session = Depends(get_db)):
    logger.debug(f"User login: {user.username}")
    user_db = db.query(User).filter(User.username == user.username).first()
    if not user_db:
        raise HTTPException(status_code=404, detail="User not found")
    if not user_db.verify_password(user.password):
        raise HTTPException(status_code=401, detail="Email or password incorrect")

    # 生成访问令牌
    access_token = create_jwt_token(
        {"sub": str(user_db.id), "type": "access"}, timedelta(days=1)
    )

    return {
        "user_id": int(user_db.id),
        "access_token": access_token,
    }


@auth.post("/refresh")
# 定义一个异步函数refresh，用于刷新用户的访问令牌
async def refresh(user_id: int = Depends(get_jwt_token_user_id)):
    access_token = create_jwt_token(
        {"sub": str(user_id), "type": "access"}, timedelta(days=1)
    )

    # 返回一个字典，包含用户ID和新的访问令牌
    return {
        "user_id": int(user_id),
        "access_token": access_token,
    }
