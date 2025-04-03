from .database import get_db as get_db
from .database import init_db as init_user_db


def init_db():
    """初始化数据库"""
    init_user_db()
