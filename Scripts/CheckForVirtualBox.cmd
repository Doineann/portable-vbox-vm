@echo off

set VBOX_INSTALL_DIR=%VBOX_MSI_INSTALL_PATH%
if "%VBOX_INSTALL_DIR:~-1%"=="\" set VBOX_INSTALL_DIR=%VBOX_INSTALL_DIR:~0,-1%

:: Check if VirtualBox is installed

if not exist "%VBOX_INSTALL_DIR%\VirtualBox.exe" (
    echo VirtualBox needs to be installed on this machine for this to work!
    goto exit_with_pause
)
goto :eof