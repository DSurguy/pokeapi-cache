@echo off
SETLOCAL

:: check for existance of setup.env and load vars from it
if exist setup.env (for /f "delims== tokens=1,2" %%G in (setup.env) do set %%G=%%H)

:: Batch scripts are terrible
:: define all env keys and defaults
SET KEYS[0]=POKEAPI_MONGO_HOST
SET KEYS[1]=POKEAPI_MONGO_PORT
SET KEYS[2]=POKEAPI_MONGO_DB
SET KEYS[3]=POKEAPI_MONGO_USER
SET KEYS[4]=POKEAPI_MONGO_PASS

SET VALUES[0]=%POKEAPI_MONGO_HOST%
SET VALUES[1]=%POKEAPI_MONGO_PORT%
SET VALUES[2]=%POKEAPI_MONGO_DB%
SET VALUES[3]=%POKEAPI_MONGO_USER%
SET VALUES[4]=%POKEAPI_MONGO_PASS%

SET DEFAULTS[0]="localhost"
SET DEFAULTS[1]="27107"
SET DEFAULTS[2]="poke"

:: Loop through keys and prompt the user for each
echo Enter a new value for each ENV var or leave blank to accept the current value.
SET i=0
:promptLoop
if defined KEYS[%i%] (
  CALL :promptVar %i% %%KEYS[%i%]%% %%VALUES[%i%]%% %%DEFAULTS[%i%]%%
  set /a "i+=1"
  GOTO :promptLoop
)

:: Write all keys to the setup.env file
SET i=0
break> setup.env
:writeLoop
if defined KEYS[%i%] (
  call echo %%KEYS[%i%]%%=%%VALUES[%i%]%% >> setup.env
  set /a "i+=1"
  GOTO :writeLoop
)
EXIT /B 0 :: Main exit

::FUNCTION promptVar
:: Prompt the user for a key, displaying current or default value
:: {index} {keyName} {currentValue} {defaultValue}
:promptVar
  SET INDEX=%1
  SET KEY=%2
  if NOT [%3]==[] (
    SET CURVAL=%~3%
  ) else (
    SET CURVAL=%~4%
  )
  SET USERRESPONSE=
  SET /p USERRESPONSE="%KEY% (%CURVAL%): "
  if [%USERRESPONSE%]==[] (
    SET VALUES[%1]=%CURVAL%
  ) else (
    SET VALUES[%1]=%USERRESPONSE%
  )
EXIT /B 0 :: end promptVar
ENDLOCAL