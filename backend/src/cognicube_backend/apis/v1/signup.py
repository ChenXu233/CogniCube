import uuid
from datetime import datetime, timedelta, UTC, timezone

from fastapi import APIRouter, HTTPException, Depends, Request
from sqlalchemy.orm import Session

from fastapi.responses import HTMLResponse

from cognicube_backend.schemas.user import UserCreate
from cognicube_backend.services.email_service import send_verification_email
from cognicube_backend.databases.database import get_db
from cognicube_backend.models.user import User, create_user
from cognicube_backend.utils.create_html_page import generate_html_page


signup = APIRouter(prefix="/apis/v1/auth")


@signup.post("/register")
async def signup_user(
    request: Request, user: UserCreate, db: Session = Depends(get_db)
):
    # 确保用户名和邮箱的唯一性
    db_user = (
        db.query(User)
        .filter((User.username == user.username) | (User.email == user.email))
        .first()
    )

    # 生成用户验证token，并在5分钟后过期
    verfication_token = str(uuid.uuid4())
    token_expiry = datetime.now(UTC) + timedelta(minutes=60)

    if not db_user:
        # 创建用户
        db_user = create_user(
            db,
            user.username,
            user.email,
            user.password,
            verfication_token,
            token_expiry,
        )
    else:
        # 如果用户已存在，则更新验证token和过期时间
        if db_user.is_verified:
            raise HTTPException(
                status_code=400, detail="User already exists and is verified"
            )
        try:
            db_user.verification_token = verfication_token
            db_user.verification_token_expiry = token_expiry
            db.commit()
        except Exception as e:
            db.rollback()
            raise HTTPException(
                status_code=500, detail=f"Error updating verification token: {str(e)}"
            ) from e

    # 发送验证邮件
    await send_verification_email(request, user.email, str(db_user.verification_token))

    return {"user_id": str(db_user.id)}


@signup.get("/verify/{token}")
async def verify_email(token: str, db: Session = Depends(get_db)):
    """根据token对邮箱进行验证"""
    db_user = db.query(User).filter(User.verification_token == token).first()

    if not db_user:
        raise HTTPException(
            status_code=400, detail="Invalid or expired verification token"
        )

    if db_user.verification_token_expiry is None:
        raise HTTPException(status_code=400, detail="Token expiry time missing")

    token_expiry_with_tz = db_user.verification_token_expiry.replace(
        tzinfo=timezone.utc
    )

    # 检查是否已经过期
    if token_expiry_with_tz < datetime.now(UTC):
        raise HTTPException(status_code=400, detail="Verification token has expired")

    # 邮箱已验证
    try:
        db_user.is_verified = True
        db_user.verification_token = None  # 将token移除
        db_user.verification_token_expiry = None  # 将token过期时间移除
        db.commit()
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=500, detail=f"Error verifying email: {str(e)}"
        ) from e

    html_page = generate_html_page(db_user.username)
    return HTMLResponse(content=html_page, status_code=200)
