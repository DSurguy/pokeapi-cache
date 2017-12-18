# Pokeapi Cache

## Description
This project serves as a simple cache for https://pokeapi.co. Resource requests are limited to 300 per day, per resource. 
This means that each resource MUST be cached in order to avoid maxing out that limit and becoming blacklisted.

## Docker
In order to facilitate quick setup and teardown, docker-compose files are provided.

**These assume existance of accompanying .env files!** Samples of these files are provided below.

- `docker-compose-both.yml`: Two containers, one for app and one for mongo
- `docker-compose-app.yml`: One container for the app

I recommend copying the file you actually want to use to `docker-compose.yml` and replacing the vars there.
Both `docker-compose.yml` and all `.env` files are added to .gitignore, so this is the safest way to avoid checking in
usernames and passwords.

```
# app.env
MONGO_HOST=localhost
MONGO_PORT=27107
MONGO_USER=--CHANGEME--
MONGO_PASS=--CHANGEME--
MONGO_DB=pokeapi-cache
```
```
# mongo.env
MONGO_INITDB_ROOT_USERNAME=--CHANGEME--
MONGO_INITDB_ROOT_PASSWORD=--CHANGEME--
```

You can remove the mongo user and pass from both of these files 
to run the db without authentication, but that seems like a bad idea.

## TODOS

- [ ] Fix windows batch script when docker for windows is also fixed.