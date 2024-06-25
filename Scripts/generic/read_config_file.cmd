@echo off
:: Reads `key=value` pairs from a config file and attempts to `set` them as environment variables.
::
:: Expected format for the config file:
::
:: - ini-file style-layout `key=value` pairs
:: - keys can only contain the following sets of characters: [a-z][A-Z][0-9][-_]
:: - values can contain other characters (some of which may not play well with `set`, so beware!)
:: - comments with //, #, :: (if any characters are not allowed in the key, the line is ignored!)
:: - same goes for ini-style sections
::
:: Limitations:
::
:: - only ASCII characters supported in the configuration file
::   (international characters don't fly well with `findstr` :/)
::

:: count number of arguments
set argCount=0
for %%x in (%*) do if not "%%~x"=="" set /a argCount+=1

if %argCount%==1 goto read-whole-file
if %argCount%==2 goto read-single-key
if %argCount%==3 goto read-single-key-into-variable
goto incorrect-number-of-passed-arguments

:read-whole-file
for /f "tokens=1,2* delims==" %%g in ('findstr /r /c:"^[ a-zA-Z_0-9\-]*=.*" "%~1"') do (
    call :trim-and-set-key-value "%%g" "%%h"
)
goto :eof

:read-single-key
for /f "tokens=1,2* delims==" %%g in ('findstr /r /c:"^[ ]*%~2[ ]*=.*" "%~1"') do (
    call :trim-and-set-key-value "%%g" "%%h"
)
goto :eof

:read-single-key-into-variable
for /f "tokens=1,2* delims==" %%g in ('findstr /r /c:"^[ ]*%~2[ ]*=.*" "%~1"') do (
    call :trim-and-set-key-value "%~3" "%%h"
)
goto :eof

:trim-and-set-key-value
:: %1 [in] string key
:: %2 [in] string value
call :trim-to-var key %~1
call :trim-to-var value %~2
::echo "set %key%=%value%" &:: FOR DEBUGGING !
set %key%=%value%
goto :eof

:trim-to-var
:: %1 [out] variable name to output result to
:: %2 [in]  string to trim (must not be a 'quoted' string)
for /f "tokens=1*" %%a in ("%*") do set "%%a=%%b"
goto :eof

:trim
:: %1 [in/out] variable name to trim
call call :trim-to-var %~1 %%%~1%%
goto :eof

:incorrect-number-of-passed-arguments
echo.
echo Reads `key=value` pairs from a config file and attempts to `set` them as environment variables.
echo.
echo Usage: 
echo.
echo   1. Read one 'key=value' into a custom variable:
echo.
echo        %~n0 [configfile] [key] [variable]
echo.
echo   2. Read one 'key=value' into a variable with the same name as 'key':
echo.
echo        %~n0 [configfile] [key]
echo.
echo   3. Read the whole file at once:
echo.
echo        %~n0 [configfile]
echo.
goto :eof