#!/bin/bash

# check for existance of setup.env and load vars from it
if [ -e setup.env ]
then
  source ./setup.env
fi

# define all env keys and defaults
KEYS=("POKEAPI_MONGO_HOST" "POKEAPI_MONGO_PORT" "POKEAPI_MONGO_DB" "POKEAPI_MONGO_USER" "POKEAPI_MONGO_PASS")
VALUES=($POKEAPI_MONGO_HOST $POKEAPI_MONGO_PORT $POKEAPI_MONGO_DB $POKEAPI_MONGO_USER $POKEAPI_MONGO_PASS)
DEFAULTS=('localhost' '27107' 'poke' )

#FUNCTION promptVar
# Prompt the user for a key, displaying current or default value
# {index} {keyName} {currentValue} {defaultValue}
promptVar () {
  INDEX=$1
  KEY=$2
  if [ -z ${3+x} ]
  then
    CURVAL=$3
  else
    CURVAL=$4
  fi
  while true; do
    read -p "$KEY ($CURVAL): " INVAL
    case $INVAL in
      "" ) VALUES[INDEX]=$CURVAL; break;;
      * ) VALUES[INDEX]=$INVAL; break;;
    esac
  done
}

# Loop through keys and prompt the user for each
echo "Enter a new value for each ENV var or leave blank to accept the current value."
for i in "${!KEYS[@]}"; do 
  promptVar $i "${KEYS[$i]}" "${VALUES[$i]}" "${DEFAULTS[$i]}"
done;

# Write all keys to the setup.env file
> setup.env;
for i in "${!KEYS[@]}"; do 
  echo "${KEYS[$i]}=${VALUES[$i]}" >> setup.env
done