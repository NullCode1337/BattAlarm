@echo off

tasklist | findstr /C:"Batt"
echo. & echo If there's nothing at the top, & echo it means EXE ain't running! & echo.
pause
exit /b 0