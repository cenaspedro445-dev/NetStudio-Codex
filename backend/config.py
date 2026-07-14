"""Configuration management."""

from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    """Application settings."""
    backend_host: str = "0.0.0.0"
    backend_port: int = 8000
    backend_env: str = "development"
    ollama_host: str = "http://localhost:11434"
    ollama_model: str = "qwen2.5-coder"
    ollama_timeout: int = 300
    database_url: str = "sqlite:///./data/app.db"
    log_level: str = "INFO"
    
    class Config:
        env_file = ".env"
        case_sensitive = False

def get_settings() -> Settings:
    """Get settings instance."""
    return Settings()
