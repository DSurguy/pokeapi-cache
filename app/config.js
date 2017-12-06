let config = {
  MONGO_HOST: process.env.POKEAPI_MONGO_HOST || 'localhost',
  MONGO_PORT: process.env.POKEAPI_MONGO_PORT || 27017,
  MONGO_USER: process.env.POKEAPI_MONGO_USER,
  MONGO_USER: process.env.POKEAPI_MONGO_PASS,
  MONGO_DB: process.env.POKEAPI_MONGO_DB || 'pokeapi-cache',
  MONGO_URL: undefined
}
config.MONGO_URL = buildMongoUrl(config);

function buildMongoUrl(configIn){
  //mongodb://[username:password@]host1[:port1][,host2[:port2],...[,hostN[:portN]]][/[database][?options]]
  var str = 'mongodb://'
  if( configIn.MONGO_USER && configIn.MONGO_PASS )
    str += `${configIn.MONGO_USER}:${configIn.MONGO_PASS}@`
  str += configIn.MONGO_HOST
  if( configIn.MONGO_PORT )
    str += `:${configIn.MONGO_PORT}`
  str += `/${configIn.MONGO_DB}`
  return str
}

module.exports = config;