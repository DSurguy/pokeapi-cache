#!/bin/bash

# check for existance of setup.env and load vars from it, also back it up
if [ -e setup.env ]
then
  # simple backup
  cp setup.env setup.env.bak
  source ./setup.env
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

# Write all keys to the setup.env file
> setup.env;
for i in "${!KEYS[@]}"; do 
  echo "${KEYS[$i]}=${VALUES[$i]}" >> setup.env
done

# Reload env vars
source ./setup.env

#clone and overwrite docker-compose file
if [ -e docker-compose.yml ]
then
  cp docker-compose.yml docker-compose.yml.bak
fi
> docker-compose.yml

# Begin write-out
echo "version: \"2\"
services:
  pokeapi-cache-app:
    container_name: pokeapi-cache-app
    restart: always
    build: .
    environment:
      - POKEAPI_MONGO_HOST: ${POKEAPI_MONGO_HOST}
      - POKEAPI_MONGO_PORT: ${POKEAPI_MONGO_PORT}
      - POKEAPI_MONGO_DB: ${POKEAPI_MONGO_DB}" >> docker-compose.yml
if [ -z ${POKEAPI_MONGO_USER+x} ]
then
  echo "       - POKEAPI_MONGO_USER: ${POKEAPI_MONGO_USER}" >> docker-compose.yml
fi
if [ -z ${POKEAPI_MONGO_PASS+x} ]
then
  echo "       - POKEAPI_MONGO_PASS: ${POKEAPI_MONGO_PASS}" >> docker-compose.yml
fi
echo "     ports:
      - \"${POKEAPI_APP_PORT}:${POKEAPI_APP_PORT}\"" >> docker-compose.yml

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
  echo "   pokeapi-cache-mongo:
      container_name: pokeapi-cache-mongo
      restart: always
      image: mongo
      environment:" >> docker-compose.yml
  if [ -z ${POKEAPI_MONGO_USER+x} ]
  then
    echo "      MONGO_INITDB_ROOT_USERNAME: ${POKEAPI_MONGO_USER}" >> docker-compose.yml
  fi
  if [ -z ${POKEAPI_MONGO_PASS+x} ]
  then
    echo "      MONGO_INITDB_ROOT_PASSWORD: ${POKEAPI_MONGO_PASS}" >> docker-compose.yml
  fi
  echo "    volumes:
      - ./_data:/data/db
    ports:
      - \"${POKEAPI_MONGO_PORT}:27107\"" >> docker-compose.yml
fi