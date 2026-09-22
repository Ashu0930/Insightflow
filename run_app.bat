@echo off
setlocal enabledelayedexpansion
title InsightFlow — Full-Stack Launcher

echo =======================================================================
echo          InsightFlow - From Raw Data to Actionable Insights
echo =======================================================================
echo.

:: 1. Check Python
echo [1/4] Checking Python environment...
python --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Python is not installed or not found in PATH!
    echo Please install Python 3.10+ from https://www.python.org/
    pause
    exit /b 1
)
for /f "tokens=*" %%v in ('python --version') do set PYTHON_VER=%%v
echo       Found: %PYTHON_VER%

:: 2. Check Node.js & npm
echo.
echo [2/4] Checking Node.js environment...
node --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Node.js is not installed or not found in PATH!
    echo Please install Node.js 18+ from https://nodejs.org/
    pause
    exit /b 1
)
for /f "tokens=*" %%v in ('node --version') do set NODE_VER=%%v
echo       Found Node: %NODE_VER%

:: 3. Setup Frontend dependencies if needed
echo.
echo [3/4] Checking frontend dependencies...
if not exist "frontend\node_modules\" (
    echo       node_modules not found. Installing frontend dependencies...
    cd frontend
    call npm.cmd install
    cd ..
) else (
    echo       Frontend dependencies are ready.
)

:: 4. Sync Database Schema & Seed Data if needed
echo.
echo [4/4] Initializing backend database...
cd backend
python -c "from app.database import create_all_tables; create_all_tables(); print('      Database tables verified.')"
cd ..

echo.
echo =======================================================================
echo                  Starting InsightFlow Services
echo =======================================================================
echo.
echo  - Backend API:       http://127.0.0.1:8001 (Docs: http://127.0.0.1:8001/docs)
echo  - Frontend Web App:  http://localhost:5173
echo.
echo  Demo Login Accounts:
echo  -------------------------------------------------------------
echo  [Admin]    admin@insightflow.demo    /  Admin@123
echo  [Customer] customer@insightflow.demo /  Customer@123
echo -------------------------------------------------------------
echo.

:: Start Backend in a new window
start "InsightFlow Backend (FastAPI :8001)" cmd /k "title InsightFlow Backend && cd /d "%~dp0backend" && uvicorn app.main:app --host 127.0.0.1 --port 8001 --reload"

:: Wait 2 seconds for backend to start
timeout /t 2 /nobreak >nul

:: Start Frontend in a new window
start "InsightFlow Frontend (Vite :5173)" cmd /k "title InsightFlow Frontend && cd /d "%~dp0frontend" && npm.cmd run dev"

:: Wait 3 seconds and open browser
timeout /t 3 /nobreak >nul
echo Opening InsightFlow in your browser...
start http://localhost:5173

echo.
echo =======================================================================
echo  InsightFlow is now running!
echo  To stop the application, close the Backend and Frontend command windows.
echo =======================================================================
echo.
pause
