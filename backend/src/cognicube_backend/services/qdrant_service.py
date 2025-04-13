import os
import platform
import shutil
import socket
import subprocess
import sys
import threading
import zipfile
from pathlib import Path

import requests
import yaml  # 新增yaml支持

from cognicube_backend.config import CONFIG
from cognicube_backend.logger import logger

QDRANT_VERSION = CONFIG.QDRANT_VERSION
QDRANT_PORT = CONFIG.QDRANT_PORT
QDRANT_HOST = CONFIG.QDRANT_HOST
STORAGE_PATH = CONFIG.STORAGE_PATH


def check_port_available():
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        return s.connect_ex((QDRANT_HOST, QDRANT_PORT)) != 0


class QdrantConfig:
    def __init__(self):
        self.system = platform.system().lower()
        self.arch = platform.machine().lower()
        self.bin_name = "qdrant.exe" if self.system == "windows" else "qdrant"
        self.install_path = self._get_install_path()
        self.config_path = self.install_path.parent / "config.yaml"  # 配置文件路径

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
            return f"{base_url}/qdrant-aarch64-unknown-linux-musl.tar.gz"
        elif self.system == "darwin":
            return (
                f"{base_url}/qdrant-x86_64-apple-darwin.tar.gz"
                if "arm" in self.arch
                else f"{base_url}/qdrant-x86_64-apple-darwin.tar.gz"
            )
        raise Exception(f"Unsupported platform: {self.system}")


config = QdrantConfig()


def create_config_file():
    """创建配置文件（如果不存在）"""
    if not config.config_path.exists():
        logger.info(f"📄 Creating config file at {config.config_path}")
        config_data = {
            "storage": {"storage_path": str(Path.cwd() / STORAGE_PATH)},
            "optimizer": {"memmap_threshold_kb": 1024},  # 优化内存使用
        }
        with open(config.config_path, "w") as f:
            yaml.dump(config_data, f)

        # 确保存储目录存在
        storage_dir = Path(STORAGE_PATH)
        storage_dir.mkdir(parents=True, exist_ok=True)


def check_qdrant_installed():
    return shutil.which(config.bin_name) or config.install_path.exists()


def install_qdrant():
    logger.info("🔧 Installing Qdrant...")
    temp_path = None
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
        logger.error(f"❌ Installation failed: {str(e)}")
        sys.exit(1)
    finally:
        if temp_path and temp_path.exists():
            temp_path.unlink()


def start_qdrant():
    """启动Qdrant服务并重定向输出到日志系统"""
    create_config_file()  # 确保配置文件存在

    command = [
        str(config.install_path),
        "--uri",
        f"http://{QDRANT_HOST}:{QDRANT_PORT}",
        "--config-path",
        str(config.config_path),
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
        cwd=config.install_path.parent,
        bufsize=1,
        **kwargs,
    )

    def log_stream(stream, logger_func, prefix=""):
        """持续读取流并记录日志"""
        for line in iter(stream.readline, ""):
            if line:
                logger_func(f"{prefix}{line.strip()}")

    stdout_thread = threading.Thread(
        target=log_stream, args=(process.stdout, logger.info, "[Qdrant] "), daemon=True
    )
    stderr_thread = threading.Thread(
        target=log_stream, args=(process.stderr, logger.error, "[Qdrant] "), daemon=True
    )
    stdout_thread.start()
    stderr_thread.start()

    return process
