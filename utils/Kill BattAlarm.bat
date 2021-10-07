@echo off

choice /t 5 /m "You sure you want to kill BattAlarm?" /d n
if %errorlevel%==0 (taskkill /F /IM "BattAlarm.exe" & pause & exit /b 0)
if %errorlevel%==1 (exit /b 2)