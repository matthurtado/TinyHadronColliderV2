@echo OFF
for %%I in (.) do set CurrDirName=%%~nxI
rmdir /S /Q builds
mkdir builds
%PLAYDATE_SDK_PATH%\bin\pdc --verbose source ".\builds\%CurrDirName%"
exit /b %ERRORLEVEL%
