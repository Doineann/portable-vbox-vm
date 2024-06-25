@echo off

:: Read configuration

call ProcessConfig.cmd
call CheckForVirtualBox.cmd

:: Compact harddisk

echo - Remove read-only attribute for harddisk image file
attrib -R "%VM_DIR%\%VM_HDD_FILE%"
echo - Compacting harddisk...
"%VBOX_INSTALL_DIR%\VBoxManage.exe" modifymedium --compact "%VM_DIR%\%VM_HDD_FILE%"
echo - Compacting complete!
echo - Set read-only attribute for harddisk image file
attrib +R "%VM_DIR%\%VM_HDD_FILE%"