@echo off
setlocal
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File "%~dp0switch-theme.ps1" toggle
echo.
pause
