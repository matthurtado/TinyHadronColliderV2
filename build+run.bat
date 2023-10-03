@echo OFF
call build.bat
for %%I in (.) do set CurrDirName=%%~nxI
if NOT %ERRORLEVEL% == 0 exit /b %ERRORLEVEL%
echo Starting Simulator ...
%PLAYDATE_SDK_PATH%\bin\PlaydateSimulator.exe ".\builds\%CurrDirName%.pdx"
