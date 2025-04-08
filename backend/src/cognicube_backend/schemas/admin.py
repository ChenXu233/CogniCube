from typing import List

from pydantic import BaseModel


class UserResponse(BaseModel):
    id: int
    username: str
    is_admin: bool

    class Config:
        from_attributes = True


class PaginatedUsers(BaseModel):
    total: int
    page: int
    per_page: int
    items: List[UserResponse]
