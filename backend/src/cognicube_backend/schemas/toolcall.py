from typing import Any, Callable, Dict, Type

from pydantic import BaseModel


class OpenAITool(BaseModel):
    """OpenAI 工具定义结构"""

    name: str
    description: str
    parameters: Dict[str, Any]


class ToolCallRequest(BaseModel):
    """工具调用请求"""

    call_id: str
    name: str
    arguments: Dict[str, Any]


class ToolCallResponse(BaseModel):
    """工具调用响应"""

    call_id: str
    content: str
    status: str = "success"


class ToolMetadata(BaseModel):
    """工具元数据"""

    name: str
    func: Callable
    description: str
    parameters_schema: Type[BaseModel]
    return_type: Type
