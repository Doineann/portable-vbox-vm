@echo off

:: Read configuration

call ProcessConfig.cmd
call CheckForVirtualBox.cmd

:: Run the VM!

echo - Starting VM...
"%VBOX_INSTALL_DIR%\VBoxManage.exe" startvm "%VM_VBOX_UUID%" > nul