@echo off

:: Read configuration

call ProcessConfig.cmd
call CheckForVirtualBox.cmd

:: Check if the disk is already detached

"%VBOX_INSTALL_DIR%\VBoxManage.exe" showvminfo "%VM_VBOX_UUID%" --machinereadable | findstr /c:"\"SATA-0-0\"=\"none\"" > nul
if %errorlevel% == 0 goto :eof

:: Detach harddisk

echo - Detach harddisk
"%VBOX_INSTALL_DIR%\VBoxManage.exe" storageattach "%VM_VBOX_UUID%" --storagectl SATA --port 0 --device 0 --medium none
echo - Set read-only attribute for harddisk image file
attrib +R "%VM_DIR%\%VM_HDD_FILE%"