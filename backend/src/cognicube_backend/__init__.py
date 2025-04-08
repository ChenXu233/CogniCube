from cognicube_backend.apis import router_manager
from cognicube_backend.app import create_app
from cognicube_backend.databases import init_db

APP = create_app()

# 初始化数据库和路由
init_db()
router_manager.init_router(APP)


@APP.get("/")
async def root():
    return {"message": "please don't use this endpoint"}
