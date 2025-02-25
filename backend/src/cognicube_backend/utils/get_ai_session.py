import aiohttp
from fastapi import HTTPException, status
from cognicube_backend.config import CONFIG
from typing import Optional

SESSION: Optional[aiohttp.ClientSession] = None

async def get_ai_session() -> aiohttp.ClientSession:
    """返回一个全局的 aiohttp.ClientSession 实例"""
    global SESSION
    if SESSION is None:
        SESSION = aiohttp.ClientSession()
    return SESSION

async def ai_chat_api(user_message: str) -> str:
    """调用 AI 聊天接口"""
    session = await get_ai_session()
    try:
        async with session.post(
            CONFIG.AI_API_URL,
            headers={
                "Authorization": f"Bearer {CONFIG.AI_API_KEY}",
                "Content-Type": "application/json",
            },
            json={
                "messages": [{"role": "user", "content": user_message}],
                "model": "deepseek-ai/DeepSeek-V3",
                "temperature": 0.7,
            },
        ) as response:
            response.raise_for_status()
            data = await response.json()
            return data["choices"][0]["message"]["content"]
    except aiohttp.ClientError as e:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail=f"AI服务请求失败: {str(e)}",
        )
