"""Main application."""

from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse
from contextlib import asynccontextmanager
from sqlalchemy.orm import Session
import logging
import os

from database import init_db, get_db
from services.ollama import OllamaService
from schemas import GenerateRequest, HealthResponse, TaskResponse
from config import get_settings
from database import Task

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

settings = get_settings()

@asynccontextmanager
async def lifespan(app: FastAPI):
    """Startup and shutdown events."""
    logger.info("🚀 Starting NetStudio Codex Backend")
    init_db()
    
    ollama_health = await OllamaService.check_health()
    if ollama_health:
        logger.info("✅ Ollama connected")
        default_model = await OllamaService.detect_default_model()
        logger.info(f"📦 Default model: {default_model}")
    else:
        logger.warning("⚠️ Ollama not available")
    
    yield
    logger.info("🛑 Shutting down NetStudio Codex Backend")

app = FastAPI(
    title="NetStudio Codex API",
    description="AI-powered code generation",
    version="0.1.0",
    lifespan=lifespan
)

# CORS Configuration
allowed_origins = os.getenv("ALLOWED_ORIGINS", "http://localhost:5173").split(",")
app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=False,
    allow_methods=["GET", "POST"],
    allow_headers=["Content-Type"],
)

@app.get("/")
async def root():
    """Root endpoint."""
    return {"name": "NetStudio Codex", "version": "0.1.0", "status": "running"}

@app.get("/health", response_model=HealthResponse)
async def health():
    """Health check with Ollama status."""
    ollama_health = await OllamaService.check_health()
    models = await OllamaService.list_models() if ollama_health else []
    
    return HealthResponse(
        status="healthy",
        ollama_available=ollama_health,
        models_available=models
    )

@app.get("/models")
async def list_models():
    """List available Ollama models."""
    try:
        models = await OllamaService.list_models()
        return {"models": models, "count": len(models)}
    except Exception as e:
        raise HTTPException(status_code=503, detail=str(e))

@app.post("/generate")
async def generate(request: GenerateRequest, db: Session = Depends(get_db)):
    """Generate code with streaming and persistence."""
    if not request.model:
        request.model = await OllamaService.detect_default_model()
    
    task = Task(prompt=request.prompt, model=request.model, response="")
    db.add(task)
    db.flush()
    task_id = task.id
    
    try:
        async def stream_generate():
            full_response = ""
            async for chunk in OllamaService.generate(request.prompt, request.model):
                full_response += chunk
                yield chunk + "\n"
            
            task.response = full_response
            db.commit()
        
        return StreamingResponse(stream_generate(), media_type="text/event-stream")
    except Exception as e:
        db.rollback()
        logger.error(f"Generation error: {e}")
        raise HTTPException(status_code=503, detail=str(e))

@app.get("/tasks")
async def get_tasks(db: Session = Depends(get_db)):
    """List all saved tasks."""
    tasks = db.query(Task).all()
    return [{"id": t.id, "prompt": t.prompt, "response": t.response, "model": t.model, "created_at": t.created_at.isoformat()} for t in tasks]

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        app,
        host=settings.backend_host,
        port=settings.backend_port,
        log_level=settings.log_level.lower()
    )
