@echo off
SETLOCAL

:: Read from setup env file if exists
if exist setup.env (for /f "delims== tokens=1,2" %%G in (setup.env) do set %%G=%%H)


:: set /p Var1="Prompt String"
CALL :promptVar "test"
EXIT /B 0

:: {index} {keyName} {currentValue} {defaultValue}
:promptVar
ECHO %~1
EXIT /B 0