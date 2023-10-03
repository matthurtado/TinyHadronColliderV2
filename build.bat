@echo OFF
rmdir /S /Q builds
mkdir builds
%PLAYDATE_SDK_PATH%\bin\pdc --verbose source builds\game
exit /b %ERRORLEVEL%
