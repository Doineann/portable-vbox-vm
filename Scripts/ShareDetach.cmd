@echo off

:: Read configuration

call ProcessConfig.cmd
call CheckForVirtualBox.cmd

:: Check if the share is already detached

"%VBOX_INSTALL_DIR%\VBoxManage.exe" showvminfo {"%VM_VBOX_UUID%"} --machinereadable | findstr /c:"%VM_SHARE_NAME%" > nul
if not %errorlevel% == 0 goto :eof

:: Detach the share

echo - Detach shared folder
"%VBOX_INSTALL_DIR%\VBoxManage.exe" sharedfolder remove "%VM_VBOX_UUID%" --name "%VM_SHARE_NAME%"