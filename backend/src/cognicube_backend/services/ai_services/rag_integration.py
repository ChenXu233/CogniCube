# from typing import List, Dict
# from sentence_transformers import SentenceTransformer
# import numpy as np


# class RAGMemory:
#     def __init__(self, model_name="all-MiniLM-L6-v2"):
#         self.encoder = SentenceTransformer(model_name)
#         self.memory_db = []

#     def add_memory(self, text: str, metadata: dict = None):
#         """添加记忆片段"""
#         embedding = self.encoder.encode(text)
#         self.memory_db.append(
#             {"text": text, "embedding": embedding, "metadata": metadata or {}}
#         )

#     def retrieve(self, query: str, top_k: int = 3) -> List[str]:
#         """语义检索相关记忆"""
#         query_embed = self.encoder.encode(query)
#         similarities = [np.dot(query_embed, mem["embedding"]) for mem in self.memory_db]
#         sorted_indices = np.argsort(similarities)[-top_k:]
#         return [self.memory_db[i]["text"] for i in sorted_indices]
