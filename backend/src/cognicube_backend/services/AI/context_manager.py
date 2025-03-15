    import tiktoken
    from typing import List, Dict, Optional


    class OpenAIContextManager:
        def __init__(
            self,
            model: str = "gpt-3.5-turbo",
            max_tokens: int = 6 * 1024,
            system_prompt: str = "你是一个专业助手",
            reserved_tokens: int = 800,
        ):
            self.model = model
            self.encoder = tiktoken.encoding_for_model(model)
            self.max_tokens = max_tokens
            self.reserved = reserved_tokens

            # 上下文存储结构
            self.system_messages = []  # 系统级提示（不可删除） 
            self.dialogue_stack = []  # 对话历史（自动管理）
            self.tool_calls = {}  # 工具调用链

            # 初始化系统提示
            self.add_system_message(system_prompt)

        def add_message(self, role: str, content: str, tool_call_id: Optional[str] = None):
            """添加消息并自动管理Token"""
            # 工具调用特殊处理
            if role == "tool":
                content = f"[工具响应] 调用ID: {tool_call_id}\n结果: {content}"

            message = {"role": role, "content": content}
            token_cost = self._calculate_tokens(message)

            # 智能修剪策略
            while (self.current_usage + token_cost) > (self.max_tokens - self.reserved):
                if len(self.dialogue_stack) == 0:
                    break
                removed = self.dialogue_stack.pop(0)
                self.current_usage -= removed["tokens"]

            self.dialogue_stack.append({"message": message, "tokens": token_cost})

        def add_system_message(self, content: str):
            """添加系统消息"""
            message = {"role": "system", "content": content}
            token_cost = self._calculate_tokens(message)
            self.system_messages.append({"message": message, "tokens": token_cost})

        def add_tool_call(self, name: str, args: dict):
            """记录工具调用链"""
            call_id = f"call_{len(self.tool_calls) + 1}"
            content = f"[工具调用] {name}: {args}"
            self.tool_calls[call_id] = {"name": name, "args": args}
            self.add_message("assistant", content)
            return call_id

        def build_openai_request(self) -> List[Dict]:
            """生成OpenAI兼容的请求体"""
            messages = [msg["message"] for msg in self.system_messages]
            messages += [msg["message"] for msg in self._get_effective_context()]
            return messages

        def _calculate_tokens(self, message: Dict) -> int:
            """精确计算Token消耗"""
            return len(self.encoder.encode(message["content"])) + 3  # 基础开销

        def _get_effective_context(self) -> List[Dict]:
            """动态选择有效上下文（保留最近的工具链）"""
            # 优先保留最近3轮工具调用
            tool_related = [
                msg for msg in self.dialogue_stack if "工具" in msg["message"]["content"]
            ][-3:]
            other_messages = [
                msg
                for msg in self.dialogue_stack
                if "工具" not in msg["message"]["content"]
            ]
            return tool_related + other_messages[-10:]  # 合并策略

        @property
        def current_usage(self) -> int:
            return sum(msg["tokens"] for msg in self.system_messages + self.dialogue_stack)

        @current_usage.setter
        def current_usage(self, value: int):
            self._current_usage = value
