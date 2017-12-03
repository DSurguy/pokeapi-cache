@echo off
SETLOCAL ENABLEEXTENSIONS

:: Read from setup env file if exists
if exist setup.env (for /f "delims== tokens=1,2" %%G in (setup.env) do set %%G=%%H)

:: Batch scripts are terrible.
SET INDEXES=0 1 2 3 4
SET KEYS="POKEAPI_MONGO_HOST" "POKEAPI_MONGO_PORT" "POKEAPI_MONGO_DB" "POKEAPI_MONGO_USER" "POKEAPI_MONGO_PASS"
SET VALUES=%POKEAPI_MONGO_HOST %POKEAPI_MONGO_PORT %POKEAPI_MONGO_DB %POKEAPI_MONGO_USER %POKEAPI_MONGO_PASS
SET DEFAULTS="localhost" "27107" "poke"

(for %%i in (%INDEXES%) do ( 
  echo %%i
))

:: set /p Var1="Prompt String"
CALL :promptVar "test"
EXIT /B 0

:: {index} {keyName} {currentValue} {defaultValue}
:promptVar
if NOT [%1]==[] (ECHO %~1)
if NOT [%2]==[] (ECHO %~2)
if NOT [%3]==[] (ECHO %~3)
if NOT [%4]==[] (ECHO %~4)
EXIT /B 0