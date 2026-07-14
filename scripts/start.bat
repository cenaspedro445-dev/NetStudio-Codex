@echo off
REM NetStudio Codex Start Script for Windows
setlocal enabledelayedexpansion

echo.
echo ========================================
echo NetStudio Codex - Starting...
echo ========================================
echo.

REM Check if setup was done
if not exist venv (
    echo ERROR: Virtual environment not found
    echo Please run install.bat first
    pause
    exit /b 1
fi

REM Activate virtual environment
call venv\Scripts\activate.bat

REM Check .env
if not exist .env (
    echo Creating .env file from .env.example...
    copy .env.example .env
fi

REM Load environment variables
for /f "tokens=1,2 delims==" %%a in (.env) do (
    if not "%%a"==" " if not "%%a:~0,1%"=="#" (
        set %%a=%%b
    )
fi

echo [1/4] Checking Ollama...
curl -s http://localhost:11434/api/tags >nul 2>&1
if errorlevel 1 (
    echo ERROR: Ollama is not running on http://localhost:11434
    echo Please start Ollama from https://ollama.ai
    echo.
    echo To pull a model, run:
    echo   ollama pull qwen2.5-coder
    echo.
    pause
    exit /b 1
)
echo OK: Ollama is running

echo [2/4] Checking for Qwen model...
for /f "delims=" %%i in ('curl -s http://localhost:11434/api/tags') do (
    echo %%i | findstr /C:"qwen" >nul 2>&1
    if not errorlevel 1 (
        echo OK: Qwen model found
        goto qwen_found
    )
)
echo WARNING: No Qwen model found
echo Please run: ollama pull qwen2.5-coder
echo.
:qwen_found

echo [3/4] Starting Backend (FastAPI on port 8000)...
cd backend
start "NetStudio Backend" cmd /k python -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload
cd ..

echo [4/4] Starting Frontend (React + Vite on port 5173)...
cd frontend
start "NetStudio Frontend" cmd /k npm run dev
cd ..

echo.
echo ========================================
echo Services Started!
echo ========================================
echo.
echo Backend:  http://localhost:8000
echo Frontend: http://localhost:5173
echo.
echo Open http://localhost:5173 in your browser
echo.
echo Press Ctrl+C in either terminal to stop
echo.
pause
