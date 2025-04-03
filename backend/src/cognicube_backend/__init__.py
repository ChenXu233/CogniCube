from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from cognicube_backend.apis import router_manager
from cognicube_backend.databases import init_db
from cognicube_backend.logger import logger as logger

APP = FastAPI(debug=True)


APP.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 允许所有来源，或者指定特定的来源
    allow_credentials=True,
    allow_methods=["*"],  # 允许所有方法，或者指定特定的方法
    allow_headers=["*"],  # 允许所有头，或者指定特定的头
)

init_db()

router_manager.init_router(APP)


@APP.get("/")
async def root():
    return {"message": "please don't use this endpoint"}
