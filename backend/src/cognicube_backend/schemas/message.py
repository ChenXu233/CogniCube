from pydantic import BaseModel
from typing import List,Dict, Any
from abc import ABC
from enum import Enum

class MessageType(Enum):
    TEXT = "text"
    EXPRESSION = "expression"
    
class Text(BaseModel):
    type:str = MessageType.TEXT.value
    content: str
    
    
class Expression(BaseModel):
    type:str = MessageType.EXPRESSION.value
    expression_id: int
    detail: str
    

class Message(BaseModel,ABC):
    messages: List[Text|Expression]
    plain_text: str
    reply_to: int | None = None
    timestamp: float | None = None
    who: str
    message_id: int | None = None
    extensions: Dict[str,Any] = {}
    
    def to_orm_model(self):
        pass
    
    def to_dict(self):
        return self.model_dump()
