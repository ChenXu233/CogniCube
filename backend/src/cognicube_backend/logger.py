# logger.py
import logging
import sys
from time import time
from typing import Callable

from fastapi import Request, Response
from loguru import logger

# 自定义日志格式
LOG_FORMAT = "<level>{level: <8}</level> | <green>{time:YYYY-MM-DD HH:mm:ss.SSS}</green> | <cyan>{name}</cyan>:<cyan>{function}</cyan>:<cyan>{line}</cyan> - <level>{message}</level>"


class InterceptHandler(logging.Handler):
    """拦截并重定向 FastAPI/Uvicorn 日志到 Loguru"""

    def emit(self, record: logging.LogRecord):
        try:
            level = logger.level(record.levelname).name
        except ValueError:
            level = record.levelno

        frame = logging.currentframe()
        depth = 2
        while frame and frame.f_code.co_filename == logging.__file__:
            frame = frame.f_back
            depth += 1

        logger.opt(depth=depth, exception=record.exc_info).log(
            level, record.getMessage()
        )


def setup_logging():
    """配置日志系统"""

    # 移除默认配置
    logger.remove()

    # 添加控制台输出
    logger.add(
        sys.stdout,
        format=LOG_FORMAT,
        level="DEBUG",
        backtrace=True,
        diagnose=True,
        colorize=True,
        enqueue=True,
    )

    # 添加文件输出
    logger.add(
        "logs/app_{time:YYYY-MM-DD}.log",
        rotation="00:00",
        retention="30 days",
        compression="zip",
        format=LOG_FORMAT,
        level="INFO",
        enqueue=True,
    )

    # 替换uvicorn日志处理器
    logging.basicConfig(handlers=[InterceptHandler()], level=0, force=True)
    logging.getLogger("uvicorn.access").propagate = False


async def log_requests_middleware(request: Request, call_next: Callable) -> Response:
    """请求日志中间件"""

    start_time = time()
    response = await call_next(request)
    process_time = (time() - start_time) * 1000

    logger.info(
        "Request: {method} {url} | Status: {status} | Time: {time}ms",
        method=request.method,
        url=request.url.path,
        status=response.status_code,
        time=f"{process_time:.2f}",
    )

    return response


setup_logging()

__all__ = ["logger", "log_requests_middleware"]
