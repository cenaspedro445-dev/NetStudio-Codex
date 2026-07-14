"""Ollama integration routes."""

from fastapi import APIRouter, HTTPException
from fastapi.responses import StreamingResponse
import httpx
import os

router = APIRouter(prefix="/ollama", tags=["ollama"])

OLLAMA_HOST = os.getenv("OLLAMA_HOST", "http://localhost:11434")
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL", "qwen2.5-coder")

@router.get("/models")
async def list_models():
    """List available Ollama models."""
    try:
        async with httpx.AsyncClient() as client:
            resp = await client.get(f"{OLLAMA_HOST}/api/tags")
            return resp.json()
    except Exception as e:
        raise HTTPException(status_code=503, detail=str(e))

@router.post("/generate")
async def generate(prompt: str):
    """Generate code using Ollama with streaming."""
    try:
        async def stream_response():
            async with httpx.AsyncClient() as client:
                async with client.stream(
                    "POST",
                    f"{OLLAMA_HOST}/api/generate",
                    json={"model": OLLAMA_MODEL, "prompt": prompt, "stream": True}
                ) as resp:
                    async for line in resp.aiter_lines():
                        if line:
                            yield line + "\n"
        
        return StreamingResponse(stream_response(), media_type="text/event-stream")
    except Exception as e:
        raise HTTPException(status_code=503, detail=str(e))
