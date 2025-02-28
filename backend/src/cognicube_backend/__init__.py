from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from cognicube_backend.apis.v1.auth import auth
from cognicube_backend.apis.v1.signup import signup
from cognicube_backend.apis.v1.conversation import ai
from cognicube_backend.databases import init_db


APP = FastAPI(debug=True)

APP.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 允许所有来源，或者指定特定的来源
    allow_credentials=True,
    allow_methods=["*"],  # 允许所有方法，或者指定特定的方法
    allow_headers=["*"],  # 允许所有头，或者指定特定的头
)

init_db()


@APP.get("/")
async def root():
    return {"message": "please don't use this endpoint"}


APP.include_router(auth)
APP.include_router(signup)
APP.include_router(ai)
