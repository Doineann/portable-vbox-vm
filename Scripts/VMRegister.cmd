@echo off

:: Read configuration

call ProcessConfig.cmd
call CheckForVirtualBox.cmd

:: Check if VM is already registered

"%VBOX_INSTALL_DIR%\VBoxManage.exe" list vms | findstr /c:"%VM_VBOX_UUID%" > nul
if %errorlevel% == 0 goto :eof

:: Register the VM

echo - Register Virtual Machine
"%VBOX_INSTALL_DIR%\VBoxManage.exe" registervm "%VM_DIR%\%VM_VBOX_FILE%"