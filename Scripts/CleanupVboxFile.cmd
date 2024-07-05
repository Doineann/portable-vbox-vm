@echo off

:: Read configuration

call ProcessConfig.cmd

:: Cleanup "DVDImages" from vbox file

set tag_to_check="DVDImages"
call :xml_file_contain_tag "%VM_DIR%\%VM_VBOX_FILE%" %tag_to_check%
if %errorlevel%==0 (
  echo - Removing %tag_to_check% from %VM_VBOX_FILE%...
  call :xml_file_remove_tag "%VM_DIR%\%VM_VBOX_FILE%" %tag_to_check%
)

:: Cleanup "Snapshot" from vbox file

set tag_to_check="Snapshot"
call :xml_file_contain_tag "%VM_DIR%\%VM_VBOX_FILE%" %tag_to_check%
if %errorlevel%==0 (
  echo - Removing %tag_to_check% from %VM_VBOX_FILE%...
  call :xml_file_remove_tag "%VM_DIR%\%VM_VBOX_FILE%" %tag_to_check%
)

goto :eof

:: XML file operations

:xml_file_contain_tag
findstr /m "\<%~2\>" "%~1" >nul
exit /b %errorlevel%

:xml_file_remove_tag
setlocal enableextensions disabledelayedexpansion
if exist "%~1-sanitize-backup" del "%~1-sanitize-backup"
copy "%~1" "%~1-sanitize-backup" > nul
set "print=1"
(
    for /f "usebackq delims=" %%a in ("%~1-sanitize-backup") do for /f "tokens=1 delims=/<> " %%b in ("%%a") do if "%%~b"=="%~2" (
        if defined print (set "print=") else (set "print=1")
    ) else if defined print echo(%%a) > "%~1"
)
goto :eof