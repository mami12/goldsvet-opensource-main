@echo off
title Stop Goldsvet Casino Local Server
echo Stopping all casino services...

taskkill /F /IM php.exe 2>nul
taskkill /F /IM mysqld.exe 2>nul
taskkill /F /IM redis-server.exe 2>nul
taskkill /F /IM node.exe 2>nul

echo All casino services have been stopped.
pause
