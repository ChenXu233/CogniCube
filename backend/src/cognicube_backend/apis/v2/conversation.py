from fastapi import APIRouter, Depends, HTTPException, BackgroundTasks
from sqlalchemy.orm import Session
import datetime

from cognicube_backend.databases.database import get_db
from cognicube_backend.models.user import User
from cognicube_backend.models.conversation import Who
from cognicube_backend.services.ai_service import (
    AIChatService,
)
from cognicube_backend.schemas.message import Message, Text
from cognicube_backend.utils.jwt_generator import get_jwt_token_user_id
from cognicube_backend.schemas.conversation import (
    ConversationRequest,
    ConversationResponse,
    ConversationHistoryResponse,
)
from cognicube_backend.models.async_task import (
    AsyncTask,
    TaskStatus,
)
from cognicube_backend.schemas.async_task import (  # 需要创建的新Schema
    AsyncTaskCreate,
    AsyncTaskResponse,
    TaskStatusResponse,
)
from cognicube_backend.utils.decorator import verify_email_verified


ai = APIRouter(prefix="/apis/v2/ai")


@ai.post("/conversation2", status_code=202, response_model=AsyncTaskResponse)
@verify_email_verified(get_db)
async def create_async_conversation(
    message: ConversationRequest,
    background_tasks: BackgroundTasks,
    user_id: int = Depends(get_jwt_token_user_id),
    db: Session = Depends(get_db),
):
    """异步对话接口"""
    # 验证用户
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="用户不存在")

    # 创建异步任务记录
    task = AsyncTask(
        user_id=user_id,
        status=TaskStatus.PENDING,
        request_data=message.model_dump(),
        created_at=datetime.datetime.now(),
    )
    db.add(task)
    db.commit()
    db.refresh(task)

    # 将任务加入后台处理队列
    background_tasks.add_task(process_async_conversation, task.task_id, db)

    return AsyncTaskResponse(
        task_id=task.task_id,
        status=task.status,
        check_interval=5,  # 建议的轮询间隔
        status_url=f"/apis/v1/ai/tasks/{task.task_id}/status",
    )


@ai.get("/tasks/{task_id}/status", response_model=TaskStatusResponse)
async def get_task_status(
    task_id: str,
    user_id: int = Depends(get_jwt_token_user_id),
    db: Session = Depends(get_db),
):
    """任务状态查询接口"""
    task = (
        db.query(AsyncTask)
        .filter(AsyncTask.task_id == task_id, AsyncTask.user_id == user_id)
        .first()
    )

    if not task:
        raise HTTPException(status_code=404, detail="任务不存在")

    return TaskStatusResponse(
        status=task.status,
        result=ConversationResponse(message=Message(**task.result_data))
        if task.status == TaskStatus.COMPLETED
        else None,
        created_at=int(task.created_at.timestamp()),
        updated_at=int(task.updated_at.timestamp()) if task.updated_at else None,
    )


# 异步任务处理函数
async def process_async_conversation(task_id: str, db: Session):
    """后台任务处理逻辑"""

    task = db.query(AsyncTask).filter(AsyncTask.task_id == task_id).first()
    if not task:
        return

    try:
        # 标记任务为处理中
        task.status = TaskStatus.IN_PROGRESS
        task.updated_at = datetime.datetime.now()
        db.commit()

        # 实际处理逻辑（从原接口迁移）
        ai_service = AIChatService(task.user_id, db)

        # 保存用户消息
        await ai_service.save_message_record(task.user_id, task.request_data["message"])

        # AI生成（这里假设chat方法已经是异步的）
        ai_response = await ai_service.chat(
            task.request_data["message"].get_plain_text()
        )
        ai_response_text: str = ai_response.choices[0].message.content  # type: ignore

        # 构造AI消息
        ai_message = Message(
            who=Who.AI.value,
            messages=[Text(text=ai_response_text)],
        )

        # 保存AI回复
        await ai_service.save_message_record(task.user_id, ai_message)

        # 情感分析
        await ai_service.emotion_quantification(
            task.request_data["message"].get_plain_text()
        )

        # 标记任务完成
        task.status = TaskStatus.COMPLETED
        task.result_data = ai_message.model_dump()
        task.updated_at = datetime.datetime.now()
        db.commit()

    except Exception as e:
        # 错误处理
        task.status = TaskStatus.FAILED
        task.error_info = str(e)
        task.updated_at = datetime.datetime.now()
        db.commit()
