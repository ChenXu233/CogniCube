import asyncio
import os
import platform
import shutil
import subprocess
import sys
import zipfile
import threading  # 新增线程支持
from contextlib import asynccontextmanager
from pathlib import Path

import requests
from fastapi import FastAPI
from qdrant_client import QdrantClient

from cognicube_backend.logger import logger

QDRANT_VERSION = "v1.13.6"
QDRANT_PORT = 6333
QDRANT_HOST = "127.0.0.1"


class QdrantConfig:
    def __init__(self):
        self.system = platform.system().lower()
        self.arch = platform.machine().lower()
        self.bin_name = "qdrant.exe" if self.system == "windows" else "qdrant"
        self.install_path = self._get_install_path()

    def _get_install_path(self):
        if self.system == "windows":
            return Path("./qdrant") / "bin" / self.bin_name
        else:
            return Path.home() / ".local" / "bin" / self.bin_name

    def get_download_url(self):
        base_url = (
            f"https://github.com/qdrant/qdrant/releases/download/{QDRANT_VERSION}"
        )
        if self.system == "windows":
            return f"{base_url}/qdrant-x86_64-pc-windows-msvc.zip"
        elif self.system == "linux":
            return f"{base_url}/qdrant-x86_64-unknown-linux-gnu.tar.gz"
        elif self.system == "darwin":
            if "arm" in self.arch:
                return f"{base_url}/qdrant-aarch64-apple-darwin.tar.gz"
            return f"{base_url}/qdrant-x86_64-apple-darwin.tar.gz"
        raise Exception(f"Unsupported platform: {self.system}")


config = QdrantConfig()


def check_qdrant_installed():
    return shutil.which(config.bin_name) or config.install_path.exists()


def install_qdrant():
    logger.info("🔧 Installing Qdrant...")
    try:
        url = config.get_download_url()
        download_dir = config.install_path.parent
        download_dir.mkdir(parents=True, exist_ok=True)

        logger.info(f"⬇️ Downloading from {url}")
        response = requests.get(url, timeout=30)
        temp_path = download_dir / "qdrant_temp.tar.gz"
        with open(temp_path, "wb") as f:
            f.write(response.content)

        logger.info("📦 Extracting package...")
        with zipfile.ZipFile(temp_path, "r") as zip_ref:
            zip_ref.extractall(download_dir)
        if config.system != "windows":
            os.chmod(config.install_path, 0o755)

        logger.info(f"✅ Qdrant installed to {config.install_path}")
    except Exception as e:
        logger.info(f"❌ Installation failed: {str(e)}")
        sys.exit(1)


def check_port_available():
    if config.system == "windows":
        command = f"netstat -ano | findstr :{QDRANT_PORT}"
    else:
        command = f"lsof -i :{QDRANT_PORT} || ss -ltn | grep :{QDRANT_PORT}"
    return os.system(command) != 0


def start_qdrant():
    """启动Qdrant服务并重定向输出到日志系统"""
    command = [
        str(config.install_path),
        "--uri",
        f"http://{QDRANT_HOST}:{QDRANT_PORT}",
    ]

    kwargs = {}
    if config.system == "windows":
        kwargs["creationflags"] = subprocess.CREATE_NEW_PROCESS_GROUP
    else:
        kwargs["start_new_session"] = True

    process = subprocess.Popen(
        command,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        bufsize=1,
        **kwargs,
    )

    def log_stream(stream, logger_func, prefix=""):
        """持续读取流并记录日志"""
        for line in iter(stream.readline, ""):
            if line:
                logger_func(f"{prefix}{line.strip()}")

    # 启动日志记录线程
    stdout_thread = threading.Thread(
        target=log_stream, args=(process.stdout, logger.info, "[Qdrant] "), daemon=True
    )
    stderr_thread = threading.Thread(
        target=log_stream, args=(process.stderr, logger.error, "[Qdrant] "), daemon=True
    )
    stdout_thread.start()
    stderr_thread.start()

    return process  # 返回进程对象


@asynccontextmanager
async def lifespan(app: FastAPI):
    # 服务启动逻辑
    if not check_port_available():
        logger.info(f"🚨 Port {QDRANT_PORT} is occupied!")
        sys.exit(1)

    if not check_qdrant_installed():
        logger.info("🔄 Qdrant not found, starting installation...")
        install_qdrant()

    logger.info("🚀 Starting Qdrant service...")
    qdrant_process = start_qdrant()
    app.state.qdrant_process = qdrant_process  # 存储进程对象
    await asyncio.sleep(5)

    try:
        app.state.client = QdrantClient(host=QDRANT_HOST, port=QDRANT_PORT)
        app.state.client.get_collections()
        logger.info("🔗 Qdrant service connected")
    except Exception as e:
        logger.info(f"❌ Failed to connect Qdrant: {str(e)}")
        sys.exit(1)

    yield  # 应用运行期间

    # 服务停止逻辑
    logger.info("🛑 Stopping Qdrant service...")
    if hasattr(app.state, "qdrant_process"):
        process = app.state.qdrant_process
        process.terminate()
        try:
            process.wait(timeout=5)
        except subprocess.TimeoutExpired:
            process.kill()
            process.wait()
        logger.info("✅ Qdrant stopped")
