#!/bin/bash
# NetStudio Codex Setup Script for Linux/macOS

set -e

echo ""
echo "========================================"
echo "NetStudio Codex - Setup"
echo "========================================"
echo ""

# Check Python
echo "[1/8] Checking Python..."
if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python 3 is not installed"
    echo "Please install Python 3.10+ from https://www.python.org"
    exit 1
fi
PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
echo "✓ Python $PYTHON_VERSION"

# Check Node.js
echo "[2/8] Checking Node.js..."
if ! command -v node &> /dev/null; then
    echo "ERROR: Node.js is not installed"
    echo "Please install Node.js from https://nodejs.org"
    exit 1
fi
NODE_VERSION=$(node --version)
echo "✓ Node.js $NODE_VERSION"

# Check npm
echo "[3/8] Checking npm..."
if ! command -v npm &> /dev/null; then
    echo "ERROR: npm is not installed"
    exit 1
fi
NPM_VERSION=$(npm --version)
echo "✓ npm $NPM_VERSION"

# Check Git
echo "[4/8] Checking Git..."
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version | awk '{print $3}')
    echo "✓ Git $GIT_VERSION"
else
    echo "⚠ Git is not installed (optional)"
fi

# Check Ollama
echo "[5/8] Checking Ollama..."
if curl -s http://localhost:11434/api/tags &> /dev/null; then
    echo "✓ Ollama is running"
else
    echo "⚠ Ollama is not running"
    echo "   Start it from https://ollama.ai"
fi

# Create virtual environment
echo "[6/8] Setting up Python environment..."
if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo "Created virtual environment"
fi

# Activate virtual environment
source venv/bin/activate

# Install backend dependencies
echo "[7/8] Installing backend dependencies..."
if [ -f "backend/requirements.txt" ]; then
    cd backend
    pip install -q -r requirements.txt
    cd ..
    echo "✓ Backend dependencies installed"
else
    echo "⚠ backend/requirements.txt not found"
fi

# Install frontend dependencies
echo "[8/8] Installing frontend dependencies..."
if [ -f "frontend/package.json" ]; then
    cd frontend
    npm install --silent
    cd ..
    echo "✓ Frontend dependencies installed"
else
    echo "⚠ frontend/package.json not found"
fi

# Create .env file
if [ ! -f ".env" ]; then
    echo "Creating .env file..."
    cp .env.example .env
    echo "✓ .env created"
else
    echo "✓ .env already exists"
fi

echo ""
echo "========================================"
echo "Setup Complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "  1. Start Ollama if not running:"
echo "     https://ollama.ai"
echo "  2. Pull Qwen model:"
echo "     ollama pull qwen2.5-coder"
echo "  3. Run ./start.sh to start the application"
echo ""
