# Pokeapi Cache

## Description
This project serves as a simple cache for https://pokeapi.co. Resource requests are limited to 300 per day, per resource. 
This means that each resource MUST be cached in order to avoid maxing out that limit and becoming blacklisted.

## Docker
In order to facilitate quick setup and teardown, docker-compose files are provided.

- `docker-compose-both.yml`: Two containers, one for app and one for mongo
  - In this image, a default mongo user/pass of `--CHANGEME--` is provided. Please change this. See todos for future improvements!
- `docker-compose-app.yml`: One container for the app

I recommend copying the file you actually want to use to `docker-compose.yml` and replacing the vars there.
`docker-compose.yml` is added to .gitignore, so it is the safest way to not accidentally check in user/pass!

## TODOS

- [ ] Create bash and batch scripts to configure docker-compose files with env vars set