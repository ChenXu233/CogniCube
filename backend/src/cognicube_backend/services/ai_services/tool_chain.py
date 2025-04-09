import inspect
import json
from typing import Any, Callable, Dict, List, Type

from openai import AsyncOpenAI
from openai.types.chat import (ChatCompletionMessageParam,
                               ChatCompletionToolMessageParam,
                               ChatCompletionToolParam,
                               ChatCompletionUserMessageParam)
from openai.types.shared_params import FunctionDefinition
from pydantic import BaseModel, ConfigDict, Field, create_model

from cognicube_backend.logger import logger
from cognicube_backend.schemas.toolcall import (OpenAITool, ToolCallResponse,
                                                ToolMetadata)


class ToolExecutionError(Exception):
    """工具执行异常"""

    def __init__(self, tool_name: str, error: str):
        self.tool_name = tool_name
        self.error = error
        super().__init__(f"Tool {tool_name} execution error: {error}")


class ToolRegistry:
    """工具注册中心"""

    def __init__(self):
        self.tools: Dict[str, ToolMetadata] = {}
        self.param_models: Dict[str, Type[BaseModel]] = {}

    def register(
        self,
        name: str,
        description: str,
        param_descriptions: Dict[str, str] = {},
    ) -> Callable:
        """工具注册装饰器"""

        def decorator(func: Callable) -> Callable:
            logger.info(f"Registering tool: {name}")
            sig = inspect.signature(func)
            parameters = list(sig.parameters.values())

            # 构建参数模型
            fields = {}
            for param in parameters:
                field_info = Field()
                if param.name in param_descriptions:
                    field_info.description = param_descriptions[param.name]

                fields[param.name] = (
                    param.annotation
                    if param.annotation != inspect.Parameter.empty
                    else Any,
                    field_info,
                )

            param_model = create_model(
                f"{name}Params", **fields, __config__=ConfigDict(extra="forbid")
            )

            # 保存元数据
            self.tools[name] = ToolMetadata(
                name=name,
                func=func,
                description=description,
                parameters_schema=param_model,
                return_type=sig.return_annotation,
            )
            self.param_models[name] = param_model

            logger.info(f"Tool {name} registered successfully.")
            return func

        return decorator

    def get_openai_tools(self) -> List[OpenAITool]:
        """生成OpenAI兼容工具列表"""
        logger.info("Generating OpenAI-compatible tool list.")
        return [
            OpenAITool(
                name=tool.name,
                description=tool.description,
                parameters=tool.parameters_schema.model_json_schema(),
            )
            for tool in self.tools.values()
        ]


class OpenAIToolExecutor:
    """OpenAI 工具执行器"""

    def __init__(self, registry: ToolRegistry, client: AsyncOpenAI):
        self.registry = registry
        self.client = client
        self.message_history: List[ChatCompletionMessageParam] = []
        logger.info("OpenAIToolExecutor initialized.")

    async def execute_tool_call(self, tool_call: Dict[str, Any]) -> ToolCallResponse:
        """执行单个工具调用"""
        logger.info(f"Executing tool call: {tool_call['name']}")
        try:
            # 参数校验和解析
            metadata = self.registry.tools.get(tool_call["name"])
            if not metadata:
                logger.error(f"Tool {tool_call['name']} not registered.")
                raise ToolExecutionError(tool_call["name"], "Tool not registered")

            # 参数解析
            if metadata.parameters_schema:
                args = metadata.parameters_schema(**tool_call["arguments"]).model_dump()
            else:
                args = tool_call["arguments"]

            # 执行工具
            result = (
                await metadata.func(**args)
                if inspect.iscoroutinefunction(metadata.func)
                else metadata.func(**args)
            )

            logger.info(f"Tool {tool_call['name']} executed successfully.")
            return ToolCallResponse(call_id=tool_call["id"], content=str(result))
        except Exception as e:
            logger.error(f"Error executing tool {tool_call['name']}: {str(e)}")
            return ToolCallResponse(
                call_id=tool_call["id"], content=f"Error: {str(e)}", status="error"
            )

    async def chat_completion(
        self, model: str = "deepseek-ai/DeepSeek-V3", max_retry: int = 3, **kwargs
    ) -> str:
        """带自动工具调用的聊天补全"""
        retry = 0
        logger.info("Starting chat completion with tool integration.")
        while retry <= max_retry:
            try:
                # 发送请求
                logger.info(f"Sending chat completion request (retry {retry}).")
                response = await self.client.chat.completions.create(
                    model=model,
                    messages=self.message_history,
                    tools=[
                        ChatCompletionToolParam(
                            function=FunctionDefinition(
                                name=tool.name,
                                description=tool.description,
                                parameters=tool.parameters,
                                strict=True,
                            ),
                            type="function",
                        )
                        for tool in self.registry.get_openai_tools()
                    ],
                    **kwargs,
                )

                message = response.choices[0].message
                self.message_history.append(message)

                # 无工具调用直接返回
                if not message.tool_calls:
                    logger.info("No tool calls detected. Returning response.")
                    return message.content

                # 处理所有工具调用
                tool_responses = []
                for tool_call in message.tool_calls:
                    func_call = tool_call.function
                    response = await self.execute_tool_call(
                        {
                            "id": tool_call.id,
                            "name": func_call.name,
                            "arguments": json.loads(func_call.arguments),
                        }
                    )
                    tool_responses.append(response)

                # 添加工具响应到历史
                for resp in tool_responses:
                    self.message_history.append(
                        ChatCompletionToolMessageParam(
                            role="tool",
                            content=json.dumps(resp.model_dump(), ensure_ascii=False),
                            tool_call_id=resp.call_id,
                        )
                    )

                retry += 1
            except Exception as e:
                logger.error(f"Error during chat completion: {str(e)}")
                retry += 1

        logger.error("Exceeded maximum retry attempts.")
        raise RuntimeError("Exceeded maximum retry attempts")


tool_registry = ToolRegistry()

# 使用示例
if __name__ == "__main__":
    import asyncio

    registry = ToolRegistry()
    client = AsyncOpenAI()

    @registry.register(
        name="计算器",
        description="涉及到的任何计算，都要使用这个工具",
        param_descriptions={
            "a": "第一个操作数",
            "b": "第二个操作数",
            "operation": "只能选择以下的计算类型: add/subtract/multiply/divide",
        },
    )
    async def calculator(operation: str, a: float, b: float) -> float:
        match operation:
            case "add":
                return a + b
            case "subtract":
                return a - b
            case "multiply":
                return a * b
            case "divide":
                return a / b
            case _:
                raise ValueError("Invalid operation")

    async def main():
        executor = OpenAIToolExecutor(registry, client)
        executor.message_history.append(
            ChatCompletionUserMessageParam(
                role="user", content="请计算乘5164以5465等于多少"
            )
        )

        try:
            result = await executor.chat_completion()
            logger.info(f"Final result: {result}")
        except Exception as e:
            logger.error(f"Error: {str(e)}")

    asyncio.run(main())
