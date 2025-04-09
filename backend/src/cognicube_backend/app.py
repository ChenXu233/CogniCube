import asyncio
import subprocess
import sys
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from qdrant_client import QdrantClient

from cognicube_backend.logger import logger
from cognicube_backend.services.ai_services.rag_integration import \
    VectorDBMemorySystem
from cognicube_backend.services.qdrant_service import (QDRANT_HOST,
                                                       QDRANT_PORT,
                                                       check_port_available,
                                                       check_qdrant_installed,
                                                       install_qdrant,
                                                       start_qdrant)

VECTOR_MEMORY_SYSTEM: VectorDBMemorySystem | None = None


def get_memory_system() -> VectorDBMemorySystem:
    """返回一个全局的 VectorDBMemorySystem 实例"""
    global VECTOR_MEMORY_SYSTEM
    if VECTOR_MEMORY_SYSTEM is None:
        VECTOR_MEMORY_SYSTEM = VectorDBMemorySystem()
    return VECTOR_MEMORY_SYSTEM


@asynccontextmanager
async def lifespan(app: FastAPI):
    if not check_port_available():
        logger.error(f"🚨 Port {QDRANT_PORT} is occupied!")
        sys.exit(1)

    if not check_qdrant_installed():
        logger.info("🔄 Qdrant not found, starting installation...")
        install_qdrant()

    logger.info("🚀 Starting Qdrant service...")
    qdrant_process = start_qdrant()
    app.state.qdrant_process = qdrant_process
    await asyncio.sleep(5)

    try:
        app.state.client = QdrantClient(host=str(QDRANT_HOST), port=QDRANT_PORT)
        app.state.client.get_collections()
        logger.info("🔗 Qdrant service connected")
    except Exception as e:
        logger.error(f"❌ Failed to connect Qdrant: {str(e)}")
        sys.exit(1)

    get_memory_system()

    yield

    logger.info("🛑 Stopping Qdrant service...")
    if hasattr(app.state, "qdrant_process"):
        process: subprocess.Popen = app.state.qdrant_process
        process.terminate()

        try:
            # 首次等待正常退出
            exit_code = process.wait(timeout=5)
            if exit_code != 0:
                logger.warning(f"Qdrant exited with non-zero code: {exit_code}")
        except subprocess.TimeoutExpired:
            logger.warning("Qdrant did not terminate gracefully, forcing kill...")
            try:
                # 强制终止并等待
                process.kill()
                process.wait()
            except Exception as e:
                logger.error(f"Failed to kill Qdrant: {str(e)}")

        # 最终状态确认
        if process.poll() is None:
            logger.error("❌ Qdrant failed to stop")
        else:
            logger.info("✅ Qdrant stopped")

        # 清理进程引用
        del app.state.qdrant_process
    else:
        logger.info("Qdrant service was not running")


def create_app() -> FastAPI:
    app = FastAPI(debug=True, lifespan=lifespan)

    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    return app
