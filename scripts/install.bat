@echo off
REM NetStudio Codex Setup Script for Windows
setlocal enabledelayedexpansion

echo.
echo ========================================
echo NetStudio Codex - Setup
echo ========================================
echo.

REM Check Python
echo [1/8] Checking Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python 3.10+ from https://www.python.org
    echo Make sure to check "Add Python to PATH"
    pause
    exit /b 1
)
for /f "tokens=2" %%i in ('python --version') do set PYTHON_VERSION=%%i
echo OK: Python !PYTHON_VERSION!

REM Check Node.js
echo [2/8] Checking Node.js...
node --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Node.js is not installed
    echo Please install Node.js from https://nodejs.org
    pause
    exit /b 1
)
for /f %%i in ('node --version') do set NODE_VERSION=%%i
echo OK: Node.js !NODE_VERSION!

REM Check npm
echo [3/8] Checking npm...
npm --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: npm is not installed
    pause
    exit /b 1
)
for /f %%i in ('npm --version') do set NPM_VERSION=%%i
echo OK: npm !NPM_VERSION!

REM Check Git
echo [4/8] Checking Git...
git --version >nul 2>&1
if errorlevel 1 (
    echo WARNING: Git is not installed
    echo This is optional but recommended
) else (
    for /f "tokens=3" %%i in ('git --version') do set GIT_VERSION=%%i
    echo OK: Git !GIT_VERSION!
)

REM Check Ollama
echo [5/8] Checking Ollama...
curl -s http://localhost:11434/api/tags >nul 2>&1
if errorlevel 1 (
    echo WARNING: Ollama is not running
    echo Please start Ollama from https://ollama.ai
    echo You can start it after setup
) else (
    echo OK: Ollama is running
)

REM Create virtual environment
echo [6/8] Setting up Python environment...
if not exist venv (
    python -m venv venv
    echo Created virtual environment
)

REM Activate virtual environment
echo Activating virtual environment...
call venv\Scripts\activate.bat

REM Install backend dependencies
echo [7/8] Installing backend dependencies...
if exist backend\requirements.txt (
    cd backend
    pip install -q -r requirements.txt
    cd ..
    echo OK: Backend dependencies installed
) else (
    echo WARNING: backend/requirements.txt not found
)

REM Install frontend dependencies
echo [8/8] Installing frontend dependencies...
if exist frontend\package.json (
    cd frontend
    call npm install --silent
    cd ..
    echo OK: Frontend dependencies installed
) else (
    echo WARNING: frontend/package.json not found
)

REM Create .env file
if not exist .env (
    echo Creating .env file...
    copy /Y .env.example .env >nul
    echo OK: .env created
) else (
    echo OK: .env already exists
)

echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo Next steps:
echo   1. Start Ollama if not running:
    echo      https://ollama.ai
echo   2. Pull Qwen model:
echo      ollama pull qwen2.5-coder
echo   3. Run start.bat to start the application
echo.
pause
