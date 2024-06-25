@echo off

:: Read configuration

call ProcessConfig.cmd
call CheckForVirtualBox.cmd

:: Check if VM is already registered

"%VBOX_INSTALL_DIR%\VBoxManage.exe" list vms | findstr /c:"%VM_VBOX_UUID%" > nul
if not %errorlevel% == 0 goto :eof

:: Unregister the VM

echo - Unregister Virtual Machine
"%VBOX_INSTALL_DIR%\VBoxManage.exe" unregistervm "%VM_VBOX_UUID%"