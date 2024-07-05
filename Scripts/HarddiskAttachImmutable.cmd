@echo off

:: Read configuration

call ProcessConfig.cmd
call CheckForVirtualBox.cmd

:: Make sure harddisk is detached first

Call HarddiskDetach.cmd

:: Attach harddisk immutable

echo - Set read-only attribute for harddisk image file
attrib +R "%VM_DIR%\%VM_HDD_FILE%"
echo - Attach harddisk as Immutable
"%VBOX_INSTALL_DIR%\VBoxManage.exe" storageattach "%VM_VBOX_UUID%" --storagectl SATA --port 0 --device 0 --type hdd --medium "%VM_DIR%\%VM_HDD_FILE%" --mtype immutable --nonrotational on --discard on