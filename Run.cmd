@echo off
:: Run with '-keepchanges' to keep the changes made to VM.
cd Scripts
call StartScript.cmd %~1
cd ..
echo.
pause