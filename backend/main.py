"""Main application."""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse
from contextlib import asynccontextmanager
import logging

from database import init_db
from services.ollama import OllamaService
from schemas import GenerateRequest, HealthResponse
from config import get_settings

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

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
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
async def generate(request: GenerateRequest):
    """Generate code with streaming."""
    try:
        async def stream_generate():
            async for chunk in OllamaService.generate(request.prompt, request.model):
                yield chunk + "\n"
        
        return StreamingResponse(stream_generate(), media_type="text/event-stream")
    except Exception as e:
        logger.error(f"Generation error: {e}")
        raise HTTPException(status_code=503, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        app,
        host=settings.backend_host,
        port=settings.backend_port,
        log_level=settings.log_level.lower()
    )
