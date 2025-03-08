from pydantic import BaseModel
from typing import List,Dict, Any
from abc import ABC

class Text(BaseModel):
    content: str
    
class Expression(BaseModel):
    expression_id: int
    detail: str

class Message(BaseModel,ABC):
    message: List[Text|Expression]
    message_type: str
    plain_text: str
    reply_to: int | None = None
    timestamp: float | None = None
    who: str
    message_id: int | None = None
    extensions: Dict[str,Any] = {}
    
    def to_orm_model(self):
        pass
