@echo off
title InsightFlow — Seed Demo Data
echo =======================================================================
echo          InsightFlow — Seeding Demo Database & Retail Sales
echo =======================================================================
echo.
cd /d "%~dp0backend"
python seed.py
echo.
pause
