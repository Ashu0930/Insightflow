@echo off
title InsightFlow Frontend (Vite)
echo =======================================================================
echo          InsightFlow — Frontend Dev Server (React + Vite)
echo =======================================================================
echo.
cd /d "%~dp0frontend"
call npm.cmd run dev
pause
