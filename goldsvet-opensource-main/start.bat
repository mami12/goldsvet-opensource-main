@echo off
title Goldsvet Casino - Full Stack Server
color 0A
setlocal enabledelayedexpansion

echo ================================================================
echo           GOLDSVET CASINO - STARTING ENVIRONMENT
echo ================================================================
echo.

set ROOT_DIR=%~dp0
if "%ROOT_DIR:~-1%"=="\" set ROOT_DIR=%ROOT_DIR:~0,-1%

set PHP_BIN=C:\Users\User\AppData\Local\Microsoft\WinGet\Packages\PHP.PHP.8.2_Microsoft.Winget.Source_8wekyb3d8bbwe\php.exe
if not exist "%PHP_BIN%" set PHP_BIN=php.exe

set MYSQL_BIN=D:\cassino\mariadb-10.11.8-winx64\bin\mysqld.exe
set MYSQL_DATA=D:\cassino\mariadb-10.11.8-winx64\data

set REDIS_BIN=C:\Users\User\AppData\Local\Microsoft\WinGet\Packages\taizod1024.redis-windows-fork_Microsoft.Winget.Source_8wekyb3d8bbwe\Redis-8.10.2-Windows-x64-msys2\redis-server.exe
if not exist "%REDIS_BIN%" set REDIS_BIN=redis-server.exe

set SOCKET_DIR=%ROOT_DIR%\casino\PTWebSocket

echo [1/5] Starting MariaDB Database...
if exist "%MYSQL_BIN%" (
    start "MariaDB-Server" /MIN "%MYSQL_BIN%" --datadir="%MYSQL_DATA%" --port=3306
) else (
    echo [WARN] MySQL binary not found at %MYSQL_BIN%
)

echo [2/5] Starting Redis Cache Server...
if exist "%REDIS_BIN%" (
    start "Redis-Server" /MIN "%REDIS_BIN%"
) else (
    start "Redis-Server" /MIN redis-server
)

ping 127.0.0.1 -n 3 >nul

echo [3/5] Starting WebSockets (Slots, Server, Arcade)...
cd /d "%SOCKET_DIR%"
start "WS-Server" /MIN node Server.js
start "WS-Slots" /MIN node Slots.js
start "WS-Arcade" /MIN node Arcade.js

echo [4/5] Starting PHP Web Server (Frontend and Backend API)...
cd /d "%ROOT_DIR%"
start "Goldsvet-Web" /MIN "%PHP_BIN%" -S 127.0.0.1:8000 router.php

ping 127.0.0.1 -n 3 >nul

echo [5/5] Launching Casino in your default browser...
start http://127.0.0.1:8000
start http://127.0.0.1:8000/games/Sizzling777WD/index.html

echo.
echo ================================================================
echo                    ALL SERVICES ARE RUNNING!
echo ================================================================
echo  * Casino Lobby:         http://127.0.0.1:8000
echo  * Sizzling 777 Deluxe:  http://127.0.0.1:8000/games/Sizzling777WD/index.html
echo  * Admin Panel:          http://127.0.0.1:8000/backend/login
echo    - Username:           Admin
echo    - Password:           admin123
echo ================================================================
echo  To stop all services, run stop.bat
echo ================================================================
echo.
pause
