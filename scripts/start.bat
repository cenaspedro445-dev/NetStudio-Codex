@echo off
setlocal enabledelayedexpansion

echo 🚀 Starting NetStudio Codex...

REM Load environment variables
if exist .env (
    for /f "tokens=*" %%A in (.env) do (
        if not "%%A"==" " if not "%%A:~0,1%"=="#" (
            set %%A
        )
    )
) else (
    echo ⚠️  .env file not found. Creating from .env.example...
    copy .env.example .env
)

REM Create virtual environment if needed
if not exist venv (
    echo 📦 Creating virtual environment...
    python -m venv venv
)

call venv\Scripts\activate.bat

REM Start services in separate windows
echo 📦 Starting services...

echo 🔵 Starting Backend (FastAPI)...
cd backend
start "NetStudio Backend" python -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload
cd ..

echo 🟢 Starting Frontend (React + Vite)...
cd frontend
start "NetStudio Frontend" cmd /k npm run dev
cd ..

echo.
echo ✅ Services started in separate windows!
echo.
echo 📍 Backend:  http://localhost:8000
echo 📍 Frontend: http://localhost:5173
echo.
echo Close the terminal windows to stop services.
pause
