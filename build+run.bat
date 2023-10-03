@echo OFF
call build.bat
if NOT %ERRORLEVEL% == 0 exit /b %ERRORLEVEL%
echo Starting Simulator ...
%PLAYDATE_SDK_PATH%\bin\PlaydateSimulator.exe .\builds\game.pdx
