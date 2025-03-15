from fastapi import FastAPI


class RouterManager:
    def __init__(self):
        self.routers = []

    def add_router(self, router):
        self.routers.append(router)

    def add_routers(self, routers):
        self.routers.extend(routers)

    def get_router(self):
        return self.routers

    def init_router(self, app: FastAPI):
        for router in self.routers:
            app.include_router(router)
