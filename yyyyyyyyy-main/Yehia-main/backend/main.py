from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from backend import models, database
from backend.auth import router as auth_router
from backend.cms import router as cms_router

# Create the database tables
models.Base.metadata.create_all(bind=database.engine)

app = FastAPI(title="Backend API")

# Allow CORS so the frontend can communicate with the backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins in development
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include the authentication router
app.include_router(auth_router, prefix="/api/auth", tags=["auth"])
# Include the CMS router
app.include_router(cms_router, prefix="/api/cms", tags=["cms"])

@app.get("/")
def read_root():
    return {"message": "مرحباً بك في الباك اند الجديد باستخدام FastAPI!"}

@app.get("/api/health")
def health_check():
    return {"status": "ok"}

