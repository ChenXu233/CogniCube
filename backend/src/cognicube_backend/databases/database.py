"""
@Description :   实现对用户数据库模型的链接与操作
"""

from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

from cognicube_backend.config import CONFIG

engine = create_engine(CONFIG.USER_DB_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()


def init_db():
    """创建数据表"""
    Base.metadata.create_all(bind=engine)


def get_db():
    """为当前对话获取数据库"""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
