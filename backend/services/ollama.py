"""Ollama service integration."""

import httpx
import os
import logging

logger = logging.getLogger(__name__)

OLLAMA_HOST = os.getenv("OLLAMA_HOST", "http://localhost:11434")
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL", "qwen2.5-coder")
OLLAMA_TIMEOUT = int(os.getenv("OLLAMA_TIMEOUT", "300"))

class OllamaService:
    """Ollama integration service."""
    
    @staticmethod
    async def check_health():
        """Check if Ollama is running."""
        try:
            async with httpx.AsyncClient(timeout=10) as client:
                resp = await client.get(f"{OLLAMA_HOST}/api/tags")
                return resp.status_code == 200
        except Exception as e:
            logger.error(f"Ollama health check failed: {e}")
            return False
    
    @staticmethod
    async def list_models():
        """List available models."""
        try:
            async with httpx.AsyncClient(timeout=10) as client:
                resp = await client.get(f"{OLLAMA_HOST}/api/tags")
                if resp.status_code == 200:
                    data = resp.json()
                    models = data.get("models", [])
                    return [m["name"] for m in models]
        except Exception as e:
            logger.error(f"Failed to list models: {e}")
        return []
    
    @staticmethod
    async def detect_default_model():
        """Auto-detect best available model."""
        models = await OllamaService.list_models()
        
        priorities = ["qwen3", "qwen2.5-coder", "qwen2.5-coder-32b", "qwen2.5-coder-7b"]
        
        for priority in priorities:
            for model in models:
                if priority in model.lower():
                    logger.info(f"Auto-detected model: {model}")
                    return model
        
        if models:
            logger.warning(f"Using fallback model: {models[0]}")
            return models[0]
        
        return OLLAMA_MODEL
    
    @staticmethod
    async def generate(prompt: str, model: str = None):
        """Generate text with Ollama."""
        if not model:
            model = await OllamaService.detect_default_model()
        
        try:
            async with httpx.AsyncClient(timeout=OLLAMA_TIMEOUT) as client:
                async with client.stream(
                    "POST",
                    f"{OLLAMA_HOST}/api/generate",
                    json={"model": model, "prompt": prompt, "stream": True},
                    timeout=OLLAMA_TIMEOUT
                ) as resp:
                    if resp.status_code != 200:
                        raise Exception(f"Ollama error: {resp.status_code}")
                    
                    async for line in resp.aiter_lines():
                        if line:
                            yield line
        except Exception as e:
            logger.error(f"Generation failed: {e}")
            yield '{"error": "' + str(e) + '"}'
