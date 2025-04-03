from functools import wraps

from fastapi import Depends, HTTPException
from sqlalchemy.orm import Session

from cognicube_backend.models.user import User
from cognicube_backend.utils.jwt_generator import get_jwt_token_user_id


def verify_email_verified(get_db):
    def decorator(func):
        @wraps(func)
        async def wrapper(
            *args,
            user_id: int = Depends(get_jwt_token_user_id),
            db: Session = Depends(get_db),
            **kwargs
        ):
            user = db.query(User).filter(User.id == user_id).first()
            if not user:
                raise HTTPException(status_code=404, detail="用户不存在")
            if not user.is_verified:
                raise HTTPException(status_code=403, detail="邮箱未验证")
            return await func(*args, user_id=user_id, db=db, **kwargs)

        return wrapper

    return decorator
