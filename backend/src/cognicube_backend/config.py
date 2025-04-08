from pydantic_settings import BaseSettings

from cognicube_backend.logger import logger


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
    QDRANT_VERSION: str = "v1.13.6"
    QDRANT_PORT: int = 6333
    QDRANT_HOST: str = "127.0.0.1"
    STORAGE_PATH: str = "qdrant_storage"
    Model_PATH: str = "model_storage"

    class Config:
        """读取配置文件"""

        env_file = ".env"


# @lru_cache
def get_config():
    """返回设置对象，且保证只读取一次"""
    return Setting()  # type: ignore


CONFIG = get_config()
logger.debug(CONFIG)
