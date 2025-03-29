from pydantic_settings import BaseSettings
from functools import lru_cache


class Setting(BaseSettings):
    """读取环境变量"""

    MAIL_USERNAME: str
    MAIL_PASSWORD: str
    MAIL_SERVER: str = "smtp.qq.com"
    MAIL_PORT: int = 465
    MAIL_FROM: str
    MAIL_FROM_NAME: str
    USER_DB_URL: str = "sqlite:///./tests/databases/test.db"
    JWT_SECRET_KEY: str = "secret"
    AI_API_URL: str = "https://api.siliconflow.cn/v1"
    AI_MODEL_NAME: str = "deepseek-ai/DeepSeek-V3"
    AI_API_KEY: str
    AI_PROMPT: str = ""

    class Config:
        """读取配置文件"""

        env_file = ".env"


# @lru_cache
def get_config():
    """返回设置对象，且保证只读取一次"""
    return Setting()  # type: ignore


CONFIG = get_config()
print(CONFIG)
