"""Configuration management."""

from pydantic_settings import BaseSettings
from functools import lru_cache

class Settings(BaseSettings):
    """Application settings."""
    
    # Backend
    backend_host: str = "0.0.0.0"
    backend_port: int = 8000
    backend_env: str = "development"
    
    # Frontend
    vite_api_url: str = "http://localhost:8000"
    vite_api_base: str = "/api"
    
    # Ollama
    ollama_host: str = "http://localhost:11434"
    ollama_model: str = "qwen2.5-coder"
    ollama_timeout: int = 300
    
    # Database
    database_url: str = "sqlite:///./data/app.db"
    database_echo: bool = False
    
    # Logging
    log_level: str = "INFO"
    
    class Config:
        env_file = ".env"
        case_sensitive = False

@lru_cache()
def get_settings() -> Settings:
    """Get settings instance."""
    return Settings()
