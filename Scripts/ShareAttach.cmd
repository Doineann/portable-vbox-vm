@echo off

:: Read configuration

call ProcessConfig.cmd
call CheckForVirtualBox.cmd

:: Check if the share is already attached

"%VBOX_INSTALL_DIR%\VBoxManage.exe" showvminfo {"%VM_VBOX_UUID%"} --machinereadable | findstr /c:"%VM_SHARE_NAME%" > nul
if %errorlevel% == 0 goto :eof

:: Attach the share

echo - Attach shared folder
"%VBOX_INSTALL_DIR%\VBoxManage.exe" sharedfolder add "%VM_VBOX_UUID%" --name "%VM_SHARE_NAME%" --hostpath "%VM_SHARE_DIR%"