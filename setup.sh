#!/bin/bash

#clear current line: echo -ne "\033[1A\r\033[K";

#check for existance of setup.env
if [ -e setup.env ]
then
  source ./setup.env
fi

KEYS=("POKEAPI_MONGO_HOST" "POKEAPI_MONGO_PORT" "POKEAPI_MONGO_DB" "POKEAPI_MONGO_USER" "POKEAPI_MONGO_PASS")
VALUES=($POKEAPI_MONGO_HOST $POKEAPI_MONGO_PORT $POKEAPI_MONGO_DB $POKEAPI_MONGO_USER $POKEAPI_MONGO_PASS)
DEFAULTS=('localhost' '27107' 'poke' )

# {index} {keyName} {currentValue} {defaultValue}
promptVar () {
  INDEX=$1
  KEY=$2
  if [ -z ${POKEAPI_MONGO_HOST+x} ]
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


echo "Enter a new value for each ENV var or leave blank to accept the current value."
for i in "${!KEYS[@]}"; do 
  promptVar $i "${KEYS[$i]}" "${VALUES[$i]}" "${DEFAULTS[$i]}"
done;

> setup.env;
for i in "${!KEYS[@]}"; do 
  echo "${KEYS[$i]}=${VALUES[$i]}" >> setup.env
done