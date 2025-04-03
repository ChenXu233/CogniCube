import inspect
from typing import Any, Callable, Dict, List, Optional, Type

from fastapi.dependencies.utils import get_typed_signature
from pydantic import BaseModel, ConfigDict, create_model
from pydantic.fields import FieldInfo

from cognicube_backend.schemas.toolcall import ToolCallRequest, ToolCallResponse


class ToolMetadata(BaseModel):
    name: str
    description: Optional[str] = None
    parameters: Optional[Dict[str, Any]] = None
    returns: Optional[Any] = None


class ToolChainManager:
    def __init__(self):
        self._tool_registry: Dict[str, Callable] = {}
        self._tool_metadata: Dict[str, ToolMetadata] = {}
        self._tool_param_models: Dict[str, Type[BaseModel]] = {}  # 新增参数模型存储
        self._active_calls: Dict[str, Any] = {}

    def register_tool(
        self,
        name: str,
        description: Optional[str] = None,
        param_descriptions: Dict[str, str] = {},
    ):
        def decorator(func: Callable) -> Callable:
            sig = get_typed_signature(func)
            params = list(sig.parameters.values())
            param_descriptions = param_descriptions or {}  # type: ignore # noqa: F823

            fields = {}
            for param in params[1:]:
                param_name = param.name
                annotation = param.annotation
                default = (
                    param.default
                    if param.default is not inspect.Parameter.empty
                    else ...
                )

                # 处理字段信息
                field_info = (
                    param.default
                    if isinstance(param.default, FieldInfo)
                    else FieldInfo()
                )
                if param_description := param_descriptions.get(param_name):
                    field_info.description = param_description

                # 构造字段元数据
                json_schema_extra = getattr(field_info, "json_schema_extra", None) or {}
                if param_description and not field_info.description:
                    json_schema_extra["description"] = param_description

                # Pydantic 2.0 的字段定义方式
                field_info = FieldInfo.from_annotated_attribute(annotation, default)
                if param_description and not field_info.description:
                    field_info.description = param_description
                fields[param_name] = (annotation, field_info)

            # 创建参数模型（兼容 Pydantic 2.0）
            model_config = ConfigDict(extra="forbid")
            tool_model = create_model(
                f"{func.__name__}Params",
                __config__=model_config,
                __base__=BaseModel,
                **fields,
            )

            # 生成 OpenAPI Schema
            param_schema = tool_model.model_json_schema() if fields else None
            if param_schema:
                param_schema.pop("title", None)
                for prop in param_schema.get("properties", {}).values():
                    prop.pop("title", None)

            # 元数据构造
            metadata = ToolMetadata(
                name=name,
                description=description
                or (func.__doc__.strip() if func.__doc__ else None),
                parameters=param_schema,
                returns=getattr(
                    sig.return_annotation, "__name__", str(sig.return_annotation)
                ),
            )

            self._tool_registry[name] = func
            self._tool_metadata[name] = metadata
            self._tool_param_models[name] = tool_model
            return func

        return decorator

    async def process_tool_calls(
        self, requests: List[ToolCallRequest]
    ) -> List[ToolCallResponse]:
        responses = []
        for req in requests:
            tool_func = self._tool_registry.get(req.name)
            if not tool_func:
                responses.append(
                    ToolCallResponse(
                        call_id=req.call_id,
                        content=f"Tool '{req.name}' not found",
                        status="error",
                    )
                )
                continue

            try:
                # 直接使用注册时生成的参数模型
                metadata = self._tool_metadata.get(req.name)
                if metadata and metadata.parameters:
                    # 从注册信息中获取保存的参数模型
                    param_model = self._get_param_model(req.name)  # 新增辅助方法
                    parsed_args = param_model(**req.arguments).model_dump()
                else:
                    parsed_args = req.arguments

                result = (
                    await tool_func(**parsed_args)
                    if inspect.iscoroutinefunction(tool_func)
                    else tool_func(**parsed_args)
                )
                responses.append(
                    ToolCallResponse(call_id=req.call_id, content=str(result))
                )
            except Exception as e:
                responses.append(
                    ToolCallResponse(
                        call_id=req.call_id, content=f"Error: {str(e)}", status="error"
                    )
                )
        return responses

    # 新增辅助方法获取参数模型
    def _get_param_model(self, tool_name: str) -> Type[BaseModel]:
        """从注册信息中获取参数模型"""
        if tool_name not in self._tool_registry:
            raise ValueError(f"Tool '{tool_name}' not registered")

        # 这里需要访问注册时保存的模型，需要相应修改注册逻辑
        # 假设我们添加了新的存储结构 self._tool_param_models
        return self._tool_param_models[tool_name]


tool_chain = ToolChainManager()
