"""Database models and setup."""

from sqlalchemy import create_engine, Column, Integer, String, Text, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from datetime import datetime
import os

DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./data/app.db")

engine = create_engine(
    DATABASE_URL,
    connect_args={"check_same_thread": False} if "sqlite" in DATABASE_URL else {},
    echo=os.getenv("DATABASE_ECHO", "false").lower() == "true"
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

class Task(Base):
    """Task model."""
    __tablename__ = "tasks"
    
    id = Column(Integer, primary_key=True, index=True)
    prompt = Column(Text, index=True)
    response = Column(Text)
    model = Column(String(100))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

def init_db():
    """Initialize database."""
    os.makedirs("data", exist_ok=True)
    Base.metadata.create_all(bind=engine)

def get_db():
    """Get database session."""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
