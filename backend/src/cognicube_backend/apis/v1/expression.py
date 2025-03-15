from fastapi import APIRouter, Depends

from cognicube_backend.databases import get_db
from cognicube_backend.models.expressions import Expression
from cognicube_backend.schemas.expression import ExpressionRequest, ExpressionResponse

expression = APIRouter(prefix="/expression")


@expression.post(
    "/",
    response_model=ExpressionResponse,
)
async def expression_post(request: ExpressionRequest, db=Depends(get_db)):
    expression = Expression(**request.dict())
    db.add(expression)
    db.commit()
    db.refresh(expression)
    return request.description
