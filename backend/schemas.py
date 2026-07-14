"""Pydantic models."""

from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

class GenerateRequest(BaseModel):
    """Code generation request."""
    prompt: str
    model: Optional[str] = None

class TaskResponse(BaseModel):
    """Task response."""
    id: int
    prompt: str
    response: str
    model: str
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True

class HealthResponse(BaseModel):
    """Health check response."""
    status: str
    ollama_available: bool
    models_available: List[str]
