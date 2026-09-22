@echo off
title InsightFlow Backend (FastAPI)
echo =======================================================================
echo          InsightFlow — Backend Server (FastAPI / Uvicorn)
echo =======================================================================
echo.
cd /d "%~dp0backend"
uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload
pause
