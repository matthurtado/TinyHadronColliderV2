@echo OFF
rmdir /S /Q out
mkdir out
%PLAYDATE_SDK_PATH%\bin\pdc --verbose source out\game
exit /b %ERRORLEVEL%
