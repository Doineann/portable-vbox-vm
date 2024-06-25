@echo off

:: Read configuration

call ProcessConfig.cmd
call CheckForVirtualBox.cmd

:: Some (disabled) stuff for debugging

::call OutputDebugInfo.cmd

:: Start VM set-up, execution and tear-down sequence

echo =========================================================
echo %VM_NAME% - Virtual Machine Startup Script
echo ========================================================= 

call VMRegister.cmd
call ShareAttach.cmd
if /I "%~1"=="-keepchanges" ( 
    call HarddiskAttachMutable.cmd ) else ( 
    call HarddiskAttachImmutable.cmd 
)
call VMRun.cmd
call VMWait.cmd
call HarddiskDetach.cmd
call ShareDetach.cmd
call HarddiskRemoveFromMediaManager.cmd
call VMUnRegister.cmd

echo =========================================================