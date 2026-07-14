#!/bin/bash
set -e

echo "🚀 Starting NetStudio Codex..."

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '#' | xargs)
else
    echo "⚠️  .env file not found. Creating from .env.example..."
    cp .env.example .env
    export $(cat .env | grep -v '#' | xargs)
fi

# Activate Python virtual environment
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
fi

source venv/bin/activate

# Start services
echo "📦 Starting services..."

# Backend
echo "🔵 Starting Backend (FastAPI)..."
cd backend
python -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload &
BACKEND_PID=$!
cd ..

# Frontend
echo "🟢 Starting Frontend (React + Vite)..."
cd frontend
npm run dev &
FRONTEND_PID=$!
cd ..

echo ""
echo "✅ Services started!"
echo ""
echo "📍 Backend:  http://localhost:8000"
echo "📍 Frontend: http://localhost:5173"
echo ""
echo "Press Ctrl+C to stop all services"
echo ""

# Wait for signals
trap "kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; echo '🛑 Services stopped'; exit 0" SIGINT SIGTERM
wait
