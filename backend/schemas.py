"""Pydantic schemas."""

from pydantic import BaseModel, Field
from typing import Optional, List

class GenerateRequest(BaseModel):
    """Code generation request."""
    prompt: str = Field(..., min_length=1, max_length=10000)
    model: Optional[str] = Field(None, max_length=100)

class TaskResponse(BaseModel):
    """Task response."""
    id: int
    prompt: str
    response: str
    model: str
    created_at: str

class HealthResponse(BaseModel):
    """Health check response."""
    status: str
    ollama_available: bool
    models_available: List[str]
