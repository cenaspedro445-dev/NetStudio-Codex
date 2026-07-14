#!/bin/bash
# NetStudio Codex Start Script for Linux/macOS

set -e

echo ""
echo "========================================"
echo "NetStudio Codex - Starting..."
echo "========================================"
echo ""

# Check if setup was done
if [ ! -d "venv" ]; then
    echo "ERROR: Virtual environment not found"
    echo "Please run ./install.sh first"
    exit 1
fi

# Activate virtual environment
source venv/bin/activate

# Create .env if not exists
if [ ! -f ".env" ]; then
    echo "Creating .env file from .env.example..."
    cp .env.example .env
fi

echo "[1/4] Checking Ollama..."
if ! curl -s http://localhost:11434/api/tags &> /dev/null; then
    echo "ERROR: Ollama is not running on http://localhost:11434"
    echo "Please start Ollama from https://ollama.ai"
    echo ""
    echo "To pull a model, run:"
    echo "  ollama pull qwen2.5-coder"
    echo ""
    exit 1
fi
echo "✓ Ollama is running"

echo "[2/4] Checking for Qwen model..."
if curl -s http://localhost:11434/api/tags | grep -q qwen; then
    echo "✓ Qwen model found"
else
    echo "⚠ No Qwen model found"
    echo "Please run: ollama pull qwen2.5-coder"
    echo ""
fi

echo "[3/4] Starting Backend (FastAPI on port 8000)..."
cd backend
python -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload &
BACKEND_PID=$!
cd ..

echo "[4/4] Starting Frontend (React + Vite on port 5173)..."
cd frontend
npm run dev &
FRONTEND_PID=$!
cd ..

echo ""
echo "========================================"
echo "Services Started!"
echo "========================================"
echo ""
echo "Backend:  http://localhost:8000"
echo "Frontend: http://localhost:5173"
echo ""
echo "Opening browser..."

# Try to open browser
if command -v xdg-open &> /dev/null; then
    xdg-open "http://localhost:5173" &
elif command -v open &> /dev/null; then
    open "http://localhost:5173" &
else
    echo "Please open http://localhost:5173 in your browser"
fi

echo ""
echo "Press Ctrl+C to stop all services"
echo ""

# Wait for signals
trap "echo ''; echo 'Stopping services...'; kill $BACKEND_PID $FRONTEND_PID 2>/dev/null || true; echo '🛑 Services stopped'; exit 0" SIGINT SIGTERM
wait
