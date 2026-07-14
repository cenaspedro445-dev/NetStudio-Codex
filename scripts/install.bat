@echo off
setlocal enabledelayedexpansion

echo 🔧 Installing NetStudio Codex...

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python is not installed
    exit /b 1
)

echo ✅ Python found

REM Create virtual environment
echo 📦 Creating Python virtual environment...
python -m venv venv
call venv\Scripts\activate.bat

REM Install backend dependencies
echo 📦 Installing backend dependencies...
cd backend
pip install -r requirements.txt
cd ..

REM Install frontend dependencies
echo 📦 Installing frontend dependencies...
cd frontend
call npm install
cd ..

echo ✅ Installation complete!
echo.
echo 📝 Create .env file:
echo    copy .env.example .env
echo.
echo 🚀 Start development:
echo    start.bat
