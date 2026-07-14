@echo off
echo 🛑 Stopping NetStudio Codex services...

REM Kill processes on ports
for /f "tokens=5" %%a in ('netstat -aon ^| find ":8000"') do taskkill /PID %%a /F 2>nul
for /f "tokens=5" %%a in ('netstat -aon ^| find ":5173"') do taskkill /PID %%a /F 2>nul

echo ✅ Services stopped
