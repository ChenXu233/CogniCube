from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from pydantic import BaseModel
from typing import List

# 假设以下这些导入在你的项目中已经存在
from cognicube_backend.databases.database import get_db
from cognicube_backend.models.user import User
from cognicube_backend.schemas.user import UserCreate
from cognicube_backend.utils.jwt_generator import get_jwt_token_user_id

admin = APIRouter(prefix="/apis/v1/admin", tags=["admin"])


class UserResponse(BaseModel):
    id: int
    username: str
    is_admin: bool

    class Config:
        orm_mode = True


class PaginatedUsers(BaseModel):
    total: int
    page: int
    per_page: int
    items: List[UserResponse]


# --- Dependencies ---
async def get_current_admin(
    user_id: int = Depends(get_jwt_token_user_id), db: Session = Depends(get_db)
):
    user: User | None = db.query(User).get(user_id)
    if not user or not user.is_admin:
        raise HTTPException(status_code=403, detail="Forbidden")
    return user


# --- API Endpoints ---
@admin.get("/users", response_model=PaginatedUsers)
async def get_users_list(
    page: int = Query(1, ge=1),
    per_page: int = Query(10, ge=1, le=100),
    db: Session = Depends(get_db),
    admin_user: User = Depends(get_current_admin),
):
    offset = (page - 1) * per_page
    total = db.query(User).count()
    users = db.query(User).offset(offset).limit(per_page).all()

    return {"total": total, "page": page, "per_page": per_page, "items": users}


@admin.get("/users/{user_id}", response_model=UserResponse)
async def get_user_detail(
    user_id: int,
    db: Session = Depends(get_db),
    admin_user: User = Depends(get_current_admin),
):
    user = db.query(User).get(user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user


@admin.post("/users", response_model=UserResponse)
async def _create_user(
    user_data: UserCreate,
    db: Session = Depends(get_db),
    admin_user: User = Depends(get_current_admin),
):
    # 检查用户名是否已存在
    existing_user = db.query(User).filter(User.username == user_data.username).first()
    if existing_user:
        raise HTTPException(status_code=409, detail="Username already exists")

    new_user = User(
        username=user_data.username,
        password=user_data.password,
        email=user_data.email,
        is_verified=True,
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user


@admin.delete("/users/{user_id}")
async def delete_user(
    user_id: int,
    db: Session = Depends(get_db),
    admin_user: User = Depends(get_current_admin),
):
    user = db.query(User).get(user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # 防止删除自己
    if user.id == admin_user.id:
        raise HTTPException(status_code=400, detail="Cannot delete yourself")

    db.delete(user)
    db.commit()
    return {"message": "User deleted successfully"}
