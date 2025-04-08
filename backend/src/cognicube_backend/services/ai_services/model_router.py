from typing import Optional

from cognicube_backend.config import CONFIG
from cognicube_backend.services.ai_services.context_manager import \
    ContextManager
from cognicube_backend.services.ai_services.tool_chain_manager import \
    ToolChainManager
from openai import AsyncOpenAI

SESSION: Optional[AsyncOpenAI] = None


async def get_ai_session() -> AsyncOpenAI:
    """返回一个全局的 AsyncOpenAI 实例"""
    global SESSION
    if SESSION is None:
        SESSION = AsyncOpenAI(api_key=CONFIG.AI_API_KEY, base_url=CONFIG.AI_API_URL)
    return SESSION


class ModelRouter:
    def __init__(
        self,
        context_manager: Optional[ContextManager] = None,
        tool_chain: ToolChainManager = ToolChainManager(),
    ):
        self.tool_chain = tool_chain
        self.context_manager = context_manager if context_manager else ContextManager()
        self.client = None

    # async def chat(self, request: str) -> str:
    #     """主入口"""
    #     self.client = await get_ai_session()
    #     self.context_manager.add_message(role="user", content=request)

    #     response = await self.client.chat.completions.create(
    #         model=self.context_manager.model,
    #         messages=self.context_manager.get_context(),
    #     )

    # async def emotion_quantification(self, request:str):

    # async def dispatch_task(self, request: ModelRequest) -> ModelResponse:
    #     """任务调度主入口"""
    #     # 上下文初始化
    #     ctx_key = request.context_key or "default"
    #     context = self.context_manager.get_context(ctx_key)

    #     try:
    #         # 模型选择逻辑
    #         selected_model = self._select_model(request, context)
    #         if not selected_model:
    #             return self._create_fallback_response("No available model")

    #         # 上下文长度适配
    #         adapted_context = self._adapt_context_to_model(
    #             context, selected_model["max_tokens"]
    #         )

    #         # 执行模型调用
    #         response = await self._call_model(
    #             selected_model["handler"], adapted_context, request.task_prompt
    #         )

    #         # 上下文更新
    #         self._update_context(
    #             ctx_key, request.task_prompt, response.content, response.consumed_tokens
    #         )

    #         return response

    #     except Exception as e:
    #         return self._handle_error(request, e)

    # async def _execute_tool_call(self, prompt: str) -> ModelResponse:
    #     """执行工具调用并生成自然语言结果"""
    #     tool_name = re.findall(r"使用工具[:：]\s*(\w+)", prompt)[0]
    #     tool_args = self._parse_tool_arguments(prompt)

    #     try:
    #         result = await self.tool_chain.process_tool_calls(
    #             [{"name": tool_name, "arguments": tool_args}]
    #         )

    #         return ModelResponse(
    #             success=True,
    #             content=f"工具调用成功：{result[0].content}",
    #             consumed_tokens=0,
    #             model_used=f"Tool/{tool_name}",
    #         )
    #     except Exception as e:
    #         return ModelResponse(
    #             success=False,
    #             content=f"工具调用失败：{str(e)}",
    #             consumed_tokens=0,
    #             model_used=f"Tool/{tool_name}",
    #             needs_fallback=True,
    #         )

    # def _select_model(self, request: ModelRequest, context: List) -> Optional[Dict]:
    #     """基于多因素的模型选择算法"""
    #     candidates = []

    #     # 第一阶段筛选：基本匹配
    #     for name, config in self.registered_models.items():
    #         if self._is_model_available(name, config, request, context):
    #             candidates.append((name, config))

    #     # 优先级排序
    #     sorted_models = sorted(
    #         candidates,
    #         key=lambda x: (
    #             self._calculate_task_match_score(x[1], request),
    #             x[1]["weight"],
    #             -x[1]["max_tokens"],  # 容量大的模型优先级低
    #         ),
    #         reverse=True,
    #     )

    #     return sorted_models[0][1] if sorted_models else None

    # def _is_model_available(
    #     self, name: str, config: Dict, request: ModelRequest, context: List
    # ) -> bool:
    #     """判断模型是否可用"""
    #     if request.model_preference and name != request.model_preference:
    #         return False

    #     if (
    #         "*" not in config["task_types"]
    #         and request.task_type not in config["task_types"]
    #     ):
    #         return False

    #     if len(context) > config["max_tokens"] * 0.7:  # 保留30%余量
    #         return False

    #     return True

    # def _adapt_context_to_model(self, context: List, model_max: int) -> List:
    #     """上下文动态裁剪"""
    #     current_length = sum(len(m["content"]) for m in context)
    #     target_length = int(model_max * 0.7)  # 保留30%给新内容

    #     if current_length <= target_length:
    #         return context

    #     # 智能裁剪算法
    #     trimmed = []
    #     accumulated = 0
    #     for msg in reversed(context):
    #         msg_len = len(msg["content"])
    #         if accumulated + msg_len > target_length:
    #             remaining = target_length - accumulated
    #             if remaining > 50:  # 至少保留有意义的内容
    #                 trimmed.insert(
    #                     0, {"role": msg["role"], "content": msg["content"][-remaining:]}
    #                 )
    #             break
    #         trimmed.insert(0, msg)
    #         accumulated += msg_len

    #     return trimmed

    # async def _call_model(
    #     self, handler: Callable, context: List, prompt: str
    # ) -> ModelResponse:
    #     """统一模型调用接口"""
    #     try:
    #         # 构造符合OpenAI格式的请求
    #         messages = context.copy()
    #         messages.append({"role": "user", "content": prompt})

    #         # 异步调用
    #         if inspect.iscoroutinefunction(handler):
    #             raw_response = await handler(messages)
    #         else:
    #             raw_response = handler(messages)

    #         # 标准化响应处理
    #         return ModelResponse(
    #             success=True,
    #             content=raw_response["choices"][0]["message"]["content"],
    #             consumed_tokens=raw_response.get("usage", {}).get("total_tokens", 0),
    #             model_used=raw_response.get("model", "unknown"),
    #         )
    #     except Exception as e:
    #         return self._create_fallback_response(str(e))

    # def _update_context(self, ctx_key: str, prompt: str, response: str, tokens: int):
    #     """带压缩的上下文更新"""
    #     self.context_manager.add_message(ctx_key, "user", prompt)
    #     self.context_manager.add_message(ctx_key, "assistant", response)

    #     # 自动上下文压缩
    #     if (
    #         self.context_manager.current_tokens(ctx_key)
    #         > self.context_manager.max_total_tokens * 0.8
    #     ):
    #         self._compress_context(ctx_key)

    # def _create_fallback_response(self, error_msg: str) -> ModelResponse:
    #     """创建降级响应"""
    #     return ModelResponse(
    #         success=False,
    #         content=f"系统错误：{error_msg}",
    #         consumed_tokens=0,
    #         model_used="error",
    #         needs_fallback=True,
    #     )
