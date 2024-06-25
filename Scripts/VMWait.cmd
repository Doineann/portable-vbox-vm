@echo off

:: Read configuration

call ProcessConfig.cmd
call CheckForVirtualBox.cmd

:: Check if VM is running up

call :spinner_init "- Check if VM is up and running... "
:vm_check_if_running
call :spinner
timeout /T 1 /NOBREAK > nul
"%VBOX_INSTALL_DIR%\VBoxManage.exe" list runningvms | findstr /c:"%VM_VBOX_UUID%" > nul
if not %errorlevel% == 0 goto vm_check_if_running
call :spinner_cleanup
echo - VM is Running

:: Wait a bit before checking if it has already stopped

timeout /T 3 /NOBREAK > nul

:: Wait for VM to stop...

call :spinner_init "-- waiting for VM to stop... "
:vm_wait_for_stop_loop
"%VBOX_INSTALL_DIR%\VBoxManage.exe" list runningvms | findstr /c:"%VM_VBOX_UUID%" > nul
if not %errorlevel% == 0 goto vm_stopped
timeout /T 3 /NOBREAK > nul
call :spinner
goto vm_wait_for_stop_loop

:: VM has stopped, wait a little longer to make sure

:vm_stopped
call :spinner_cleanup
echo - VM has stopped
timeout /T 3 /NOBREAK > nul
goto :eof

:: Subroutines for spinner

:spinner_init
set i=-1
<nul (set /p z="%~1/")
goto :eof

:spinner
set /a "i = i + 1"
if %i% equ 4 set i=0
:: NOTE: these 4 lines contain a hidden `BS (backspace)` character after the `=`!
if %i% equ 0 <nul (set /p z="-")
if %i% equ 1 <nul (set /p z="\")
if %i% equ 2 <nul (set /p z="|")
if %i% equ 3 <nul (set /p z="/")
goto :eof

:spinner_cleanup
:: NOTE: this line contains a hidden `BS (backspace)` character after the `=`!
<nul (set /p z=" ")
echo.
goto :eof
