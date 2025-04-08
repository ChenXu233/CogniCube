import logging
import math
import os
import uuid
from datetime import datetime
from pathlib import Path
from typing import Callable, Dict, List, Optional, Any

import qdrant_client
from qdrant_client.models import (
    Distance,
    FieldCondition,
    Filter,
    MatchValue,
    PayloadSchemaType,
    PointIdsList,
    PointStruct,
    Range,
    ReadConsistencyType,
    VectorParams,
)
from sentence_transformers import SentenceTransformer


# 假设配置模块存在
class CONFIG:
    QDRANT_HOST = "localhost"
    QDRANT_PORT = 6333
    Model_PATH = "./models"


os.environ["SENTENCE_TRANSFORMERS_CACHE"] = Path(CONFIG.Model_PATH).as_posix()
logger = logging.getLogger(__name__)


class VectorDBMemorySystem:
    def __init__(self, host=CONFIG.QDRANT_HOST, port=CONFIG.QDRANT_PORT):
        self.client = qdrant_client.QdrantClient(host=host, port=port)
        self.encoder = SentenceTransformer(
            "paraphrase-multilingual-MiniLM-L12-v2", device="cpu"
        )
        self.collection_name = "user_memories"
        self._init_collection()

    def _init_collection(self):
        """初始化集合并创建必要索引"""
        if not self.client.collection_exists(self.collection_name):
            self.client.create_collection(
                collection_name=self.collection_name,
                vectors_config=VectorParams(
                    size=384,
                    distance=Distance.COSINE,
                    on_disk=True,
                ),
            )
            # 创建查询优化索引
            self._create_payload_indices()

    def _create_payload_indices(self):
        """创建常用查询字段的索引"""
        index_config = [
            ("user_id", PayloadSchemaType.KEYWORD),
            ("status", PayloadSchemaType.KEYWORD),
            ("timestamp", PayloadSchemaType.FLOAT),
            ("importance", PayloadSchemaType.FLOAT),
        ]
        for field, field_type in index_config:
            try:
                self.client.create_payload_index(
                    collection_name=self.collection_name,
                    field_name=field,
                    field_type=field_type,
                )
            except Exception as e:
                logger.warning(f"创建索引失败 {field}: {str(e)}")

    def add_memory(self, user_id: str, text: str, importance: float = 1.0) -> str:
        """添加记忆并返回记录ID"""
        try:
            record_id = str(uuid.uuid4())
            embedding = self.encoder.encode(text).tolist()
            point = PointStruct(
                id=record_id,
                vector=embedding,
                payload={
                    "user_id": user_id,
                    "text": text,
                    "timestamp": datetime.now().timestamp(),
                    "importance": float(importance),
                    "access_count": 0,
                    "status": "active",
                },
            )
            self.client.upsert(
                collection_name=self.collection_name,
                points=[point],
                wait=True,
            )
            return record_id
        except Exception as e:
            logger.error(
                f"添加记忆失败: {str(e)}", extra={"user_id": user_id, "text": text}
            )
            raise

    def retrieve_memories(
        self,
        user_id: str,
        query_text: str,
        top_k: int = 5,
        score_threshold: float = 0.6,
        score_weight: float = 0.5,
        importance_weight: float = 0.3,
        recency_weight: float = 0.2,
        max_age_days: int = 180,
    ) -> List[Dict[str, Any]]:
        """增强版记忆检索，支持多维度加权排序"""
        # 参数校验
        if not user_id.strip() or top_k <= 0:
            return []

        try:
            query_embedding = self.encoder.encode(query_text).tolist()
        except Exception as e:
            logger.error(f"编码失败: {str(e)}")
            return []

        # 构建复合查询过滤器
        time_filter = (
            FieldCondition(
                key="timestamp",
                range=Range(
                    gte=datetime.now().timestamp() - max_age_days * 86400,
                ),
            )
            if max_age_days > 0
            else None
        )

        filters = [
            FieldCondition(key="user_id", match=MatchValue(value=user_id)),
            FieldCondition(key="status", match=MatchValue(value="active")),
        ]
        if time_filter:
            filters.append(time_filter)

        try:
            # 扩大召回数量以提升排序质量
            results = self.client.search(
                collection_name=self.collection_name,
                query_vector=query_embedding,
                query_filter=Filter(must=filters),  # type: ignore
                limit=top_k * 3,
                score_threshold=score_threshold,
                consistency=ReadConsistencyType.MAJORITY,
            )
        except Exception as e:
            logger.error(f"查询失败: {str(e)}")
            return []

        # 多维度综合评分
        current_time = datetime.now().timestamp()
        processed = []
        for point in results:
            if not point.payload:
                continue
            try:
                payload = point.payload
                metadata = {
                    "text": payload["text"],
                    "importance": payload.get("importance", 1.0),
                    "timestamp": payload["timestamp"],
                    "access_count": payload.get("access_count", 0),
                }

                # 时间衰减计算（指数衰减）
                time_diff = current_time - metadata["timestamp"]
                recency = math.exp(-0.1 * time_diff / 86400)  # 每天衰减10%

                # 综合评分
                combined_score = (
                    point.score * score_weight
                    + metadata["importance"] * importance_weight
                    + recency * recency_weight
                )

                processed.append(
                    {
                        "id": point.id,
                        "score": point.score,
                        "combined_score": combined_score,
                        "metadata": metadata,
                    }
                )
            except KeyError as e:
                logger.warning(f"元数据缺失字段: {str(e)}")

        # 按综合评分排序并截断
        sorted_results = sorted(
            processed, key=lambda x: x["combined_score"], reverse=True
        )[:top_k]

        # 异步更新访问计数
        if sorted_results:
            self._update_access_counts([x["id"] for x in sorted_results])

        return sorted_results

    def _update_access_counts(self, record_ids):
        """批量更新访问计数"""
        try:
            self.client.set_payload(
                collection_name=self.collection_name,
                payload={"access_count": "access_count + 1"},
                points=record_ids,
                wait=False,
            )
        except Exception as e:
            logger.warning(f"更新访问计数失败: {str(e)}")

    def update_memory(
        self,
        record_id: str,
        text: Optional[str] = None,
        importance: Optional[float] = None,
        status: Optional[str] = None,
    ) -> bool:
        """更新记忆内容或元数据"""
        payload = {}
        if text is not None:
            payload["text"] = text
            payload["timestamp"] = datetime.now().timestamp()
            payload["vector"] = self.encoder.encode(text).tolist()
        if importance is not None:
            payload["importance"] = float(importance)
        if status is not None:
            payload["status"] = status

        if not payload:
            return False

        try:
            self.client.upsert(
                collection_name=self.collection_name,
                points=[
                    PointStruct(
                        id=record_id,
                        vector=payload.pop("vector", None),
                        payload=payload,
                    )
                ],
            )
            return True
        except Exception as e:
            logger.error(f"更新记忆失败: {str(e)}")
            return False

    def delete_memory(self, record_id: str) -> bool:
        """删除指定记忆"""
        try:
            self.client.delete(
                collection_name=self.collection_name,
                points_selector=PointIdsList(points=[record_id]),
            )
            return True
        except Exception as e:
            logger.error(f"删除记忆失败: {str(e)}")
            return False


class MemoryAugmentedChat:
    def __init__(
        self,
        importance_checker: Optional[Callable[[str], bool]] = None,
        response_generator: Optional[Callable[[str, List[Dict]], str]] = None,
    ):
        self.memory_db = VectorDBMemorySystem()
        self.importance_checker = importance_checker or self._default_importance_check
        self.response_generator = response_generator or self._default_response_generate

    @staticmethod
    def _default_importance_check(text: str) -> bool:
        """智能重要性检测（可替换为LLM判断）"""
        keywords = {"重要", "喜欢", "讨厌", "想要", "需要", "推荐"}
        return any(keyword in text for keyword in keywords)

    @staticmethod
    def _default_response_generate(query: str, memories: List[Dict]) -> str:
        """生成上下文感知的响应"""
        if not memories:
            return "您能详细说说这个吗？我还不太了解。"

        memory_context = "\n".join([f"• {m['metadata']['text']}" for m in memories[:3]])
        return (
            f"根据您之前提到的：\n{memory_context}\n"
            f"关于您说的【{query}】，建议您可以考虑……（此处可接入LLM生成具体建议）"
        )

    def handle_message(self, user_id: str, message: str) -> str:
        """处理用户消息的全流程"""
        try:
            # 记忆检索
            memories = self.memory_db.retrieve_memories(
                user_id=user_id,
                query_text=message,
                top_k=3,
                score_threshold=0.005,
                recency_weight=0.3,  # 更重视近期记忆
            )

            # 记忆存储
            if self.importance_checker(message):
                self.memory_db.add_memory(user_id, message)

            # 响应生成
            return self.response_generator(message, memories)

        except Exception as e:
            logger.error(f"处理消息异常: {str(e)}", exc_info=True)
            return "系统暂时无法响应，请稍后再试。"


# 使用示例
if __name__ == "__main__":
    chat_system = MemoryAugmentedChat()

    # 模拟对话流程
    user_id = "test_user_001"
    test_dialog = [
        "我喜欢吃苹果",
        "我讨厌下雨天",
        "推荐一些健康零食",
        "我喜欢看电影,我喜欢吃香蕉",
        "推荐一些电影",
    ]

    for msg in test_dialog:
        print(f"用户: {msg}")
        response = chat_system.handle_message(user_id, msg)
        print(f"系统: {response}\n")
