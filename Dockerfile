FROM node:8
RUN mkdir -p ~/pokeapi-cache
COPY ./package* ~/pokeapi-cache
COPY ./app ~/pokeapi-cache/app
WORKDIR ~/pokeapi-cache
RUN npm install
EXPOSE 8080
CMD [ “npm”, “start” ]