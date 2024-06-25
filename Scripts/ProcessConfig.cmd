@echo off

:: Determine root folder for VM

set "VM_ROOT_DIR=%~dp0\.."
for %%i in ("%VM_ROOT_DIR%") do set "VM_ROOT_DIR=%%~fi"

:: Read config file

call .\generic\read_config_file.cmd ..\Config.ini

:: Fix path syntax

if "%VM_ROOT_DIR:~-1%"=="\" set VM_ROOT_DIR=%VM_ROOT_DIR:~0,-1%
set VM_DIR=%VM_ROOT_DIR%\VM

set temppath=%VM_ROOT_DIR%\%VM_SHARE_RELATIVE_PATH%
for /f "delims==" %%A in ("%temppath%") do set VM_SHARE_DIR=%%~fA
if "%VM_SHARE_DIR:~-1%"=="\" set VM_SHARE_DIR=%VM_SHARE_DIR:~0,-1%

::Test if paths exist

for %%i in (
    "%VM_ROOT_DIR%\"
    "%VM_DIR%\"
    "%VM_ROOT_DIR%\%VM_SHARE_RELATIVE_PATH%\"
    "%VM_SHARE_DIR%\"
    "%VBOX_INSTALL_DIR%\") do ( 
    if not exist "%%i" ( 
        echo Folder %%i does not exist!
        goto exit_with_pause 
    )
)

::Test if files exist

for %%i in (
    "%VM_DIR%\%VM_VBOX_FILE%" 
    "%VM_DIR%\%VM_HDD_FILE%") do (
    if not exist "%%i" (
        echo File %%i does not exist! 
        goto exit_with_pause
    )
)

:: All is ok

goto :eof

:: Exit with a pause when there are errors

:exit_with_pause
echo. 
pause
exit