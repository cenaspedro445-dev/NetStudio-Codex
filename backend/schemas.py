"""Pydantic schemas."""

from pydantic import BaseModel
from typing import Optional, List

class GenerateRequest(BaseModel):
    """Code generation request."""
    prompt: str
    model: Optional[str] = None

class HealthResponse(BaseModel):
    """Health check response."""
    status: str
    ollama_available: bool
    models_available: List[str]
