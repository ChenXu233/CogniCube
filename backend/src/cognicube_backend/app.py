from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from cognicube_backend.services.qdrant_service import lifespan


def create_app() -> FastAPI:
    app = FastAPI(debug=True, lifespan=lifespan)

    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    return app
