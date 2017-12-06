#!/bin/bash

# check for existance of .env and load vars from it, also back it up
if [ -e .env ]
then
  # simple backup
  cp .env .env.bak
  source ./.env
fi

# define all env keys and defaults
KEYS=("POKEAPI_APP_PORT" "POKEAPI_MONGO_HOST" "POKEAPI_MONGO_PORT" "POKEAPI_MONGO_DB" "POKEAPI_MONGO_USER" "POKEAPI_MONGO_PASS")
VALUES=($POKEAPI_APP_PORT $POKEAPI_MONGO_HOST $POKEAPI_MONGO_PORT $POKEAPI_MONGO_DB $POKEAPI_MONGO_USER $POKEAPI_MONGO_PASS)
DEFAULTS=('8080' 'localhost' '27107' 'poke' )

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

# Write all keys to the .env file
> .env;
for i in "${!KEYS[@]}"; do 
  echo "${KEYS[$i]}=${VALUES[$i]}" >> .env
  case ${KEYS[$i]} in
    "POKEAPI_MONGO_USER" ) echo "MONGO_INITDB_ROOT_USERNAME=${VALUES[$i]}" >> .env;;
    "POKEAPI_MONGO_PASS" ) echo "MONGO_INITDB_ROOT_PASSWORD=${VALUES[$i]}" >> .env;;
  esac
done

# Reload env vars
source ./.env

#clone and overwrite docker-compose file
if [ -e docker-compose.yml ]
then
  cp docker-compose.yml docker-compose.yml.bak
fi
> docker-compose.yml

# Begin write-out
echo "version: \"3\"

services:
  pokeapi-cache-app:
    env_file: .env
    container_name: pokeapi-cache-app
    restart: always
    build: .
    ports:
      - \"\${POKEAPI_APP_PORT}:\${POKEAPI_APP_PORT}\"" >> docker-compose.yml

while true; do
  read -p "Run mongo in docker? (y/n): " yn
  case $yn in
    [yY]* ) yn=true; break;;
    [nN]* ) yn=false; break;;
    * ) echo -ne "\033[1A\r\033[K";
  esac
done
if [ yn==true ]
then
  echo "  pokeapi-cache-mongo:
    env_file: .env
    container_name: pokeapi-cache-mongo
    restart: always
    image: mongo
    volumes:
      - ./_data:/data/db
    ports:
      - \"\${POKEAPI_MONGO_PORT}:27107\"" >> docker-compose.yml
fi