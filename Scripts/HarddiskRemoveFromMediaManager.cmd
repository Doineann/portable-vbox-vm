@echo off

:: Read configuration

call ProcessConfig.cmd
call CheckForVirtualBox.cmd

:: Check if there are any snapshots

if exist "%VM_DIR%\Snapshots\*.vdi" goto remove_snapshots_from_media_manager_and_disk
goto remove_main_disk_from_media_manager

:: Remove snapshots from media manager

:remove_snapshots_from_media_manager_and_disk
echo - Removing snapshots from Media Manager...
for /f "delims=" %%f in ('dir /b /s "%VM_DIR%\Snapshots\*.vdi"') do (
  echo - Remove snapshot %%f from Media Manager
  "%VBOX_INSTALL_DIR%\VBoxManage.exe" closemedium "%%f"
  echo - Delete snapshot %%f
  del "%%f"
)

:: Remove main disk from media manager

:remove_main_disk_from_media_manager
echo - Remove main disk from Media Manager
"%VBOX_INSTALL_DIR%\VBoxManage.exe" closemedium "%VM_HDD_UUID%"