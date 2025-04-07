import uuid
from datetime import datetime

import qdrant_client
from qdrant_client.models import (
    Distance,
    FieldCondition,
    Filter,
    PointStruct,
    VectorParams,
    MatchValue,
)
from sentence_transformers import SentenceTransformer


class VectorDBMemorySystem:
    def __init__(self, host="localhost", port=6333):
        # 初始化向量数据库客户端
        self.client = qdrant_client.QdrantClient(host=host, port=port)
        self.encoder = SentenceTransformer("paraphrase-multilingual-MiniLM-L12-v2")

        # 创建集合（类似数据库表）
        self.collection_name = "user_memories"
        self._init_collection()

    def _init_collection(self):
        """初始化集合配置"""
        if not self.client.collection_exists(self.collection_name):
            self.client.create_collection(
                collection_name=self.collection_name,
                vectors_config=VectorParams(
                    size=384,  # 匹配模型维度
                    distance=Distance.COSINE,
                ),
            )

    def add_memory(self, user_id: str, text: str, importance=1.0):
        """添加记忆到数据库"""
        # 生成向量
        embedding = self.encoder.encode(text).tolist()

        # 构建数据结构
        point = PointStruct(
            id=str(uuid.uuid4()),
            vector=embedding,
            payload={
                "user_id": user_id,
                "text": text,
                "timestamp": datetime.now().isoformat(),
                "importance": importance,
                "access_count": 0,
            },
        )

        # 插入数据
        self.client.upsert(collection_name=self.collection_name, points=[point])

    def retrieve_memories(
        self, user_id: str, query_text: str, top_k=5, score_threshold=0.7
    ):
        """实时查询用户记忆"""
        # 生成查询向量
        query_embedding = self.encoder.encode(query_text).tolist()

        # 构建过滤条件
        user_filter = Filter(
            must=FieldCondition(key="user_id", match=MatchValue(value=user_id))
        )

        # 执行搜索
        results = self.client.search(
            collection_name=self.collection_name,
            query_vector=query_embedding,
            query_filter=user_filter,
            limit=top_k,
            score_threshold=score_threshold,
        )

        # 格式化结果并更新访问计数
        formatted = []
        for hit in results:
            if not hit.payload:
                continue
            payload = hit.payload
            self._update_access_count(str(hit.id))
            formatted.append(
                {
                    "text": payload["text"],
                    "score": hit.score,
                    "metadata": {
                        "timestamp": payload["timestamp"],
                        "importance": payload["importance"],
                        "access_count": payload["access_count"] + 1,
                    },
                }
            )
        return sorted(
            formatted,
            key=lambda x: x["score"] * x["metadata"]["importance"],
            reverse=True,
        )

    def _update_access_count(self, point_id: str):
        """更新访问次数（原子操作）"""
        self.client.set_payload(
            collection_name=self.collection_name,
            payload={"access_count": {"increment": 1}},
            points=[point_id],
        )


class MemoryAugmentedChat:
    def __init__(self):
        self.memory_db = VectorDBMemorySystem()

    def handle_message(self, user_id: str, message: str) -> str:
        # 1. 添加记忆（示例逻辑）
        if self._is_important(message):
            self.memory_db.add_memory(user_id, message)

        # 2. 检索相关记忆
        memories = self.memory_db.retrieve_memories(user_id, message)

        # 3. 生成响应（示例）
        return self._generate_response(message, memories)

    def _is_important(self, text: str) -> bool:
        """重要性检测（可替换为LLM判断）"""
        return any(keyword in text for keyword in ["喜欢", "讨厌", "重要"])

    def _generate_response(self, query: str, memories: list) -> str:
        """生成响应模板"""
        if not memories:
            return "我记住了这个信息。您能再说详细些吗？"

        memory_texts = [f"- {m['text']} (相关度: {m['score']:.2f})" for m in memories]
        return f"根据您的历史记录：\n" + "\n".join(memory_texts) + "\n建议您..."
