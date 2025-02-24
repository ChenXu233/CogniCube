from fastapi import FastAPI

from cognicube_backend.apis.v1.auth import auth
from cognicube_backend.apis.v1.signup import signup
from cognicube_backend.apis.v1.conversation import ai
from cognicube_backend.databases import init_db


APP = FastAPI()

init_db()

@APP.get("/")
async def root():
    return {"message": "please don't use this endpoint"}

APP.include_router(auth)
APP.include_router(signup)
APP.include_router(ai)