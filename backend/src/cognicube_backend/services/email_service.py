from fastapi import Request
from pydantic import SecretStr
from fastapi_mail import FastMail, MessageSchema, ConnectionConfig, MessageType
from cognicube_backend.config import CONFIG


# 邮件服务器配置
mail_config = ConnectionConfig(
    MAIL_USERNAME=CONFIG.MAIL_USERNAME,
    MAIL_PASSWORD=SecretStr(CONFIG.MAIL_PASSWORD),
    MAIL_FROM=CONFIG.MAIL_FROM,
    MAIL_PORT=CONFIG.MAIL_PORT,
    MAIL_SERVER=CONFIG.MAIL_SERVER,
    USE_CREDENTIALS=True,
    MAIL_STARTTLS=False,  # 添加这行
    MAIL_SSL_TLS=True,  # 添加这行
)


async def send_verification_email(
    request: Request, email: str, verification_token: str
):
    """发送电子邮件验证码"""
    # 使用 FastAPI 的 url_for 生成验证链接
    verification_url = request.url_for("verify_email", token=verification_token)

    print(f"Verification URL: {verification_url}")

    body = (
        f"Please verify your email by clicking the following link: {verification_url}"
    )
    message = MessageSchema(
        subject="Email Verification",
        recipients=[email],
        body=body,
        subtype=MessageType.html,
    )
    fm = FastMail(mail_config)
    try:
        await fm.send_message(message)
    except Exception as e:
        print(f"Failed to send verification email to {email}: {e}")
    print(f"Verification email sent to {email}.")
    
    return
