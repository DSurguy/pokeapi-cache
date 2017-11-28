module.exports = {
  MONGO_HOST: process.env.MONGO_HOST || 'localhost',
  MONGO_PORT: process.env.MONGO_PORT,
  MONGO_USER: process.env.MONGO_USER,
  MONGO_USER: process.env.MONGO_PASS,
  MONGO_DB: process.env.MONGO_DB || 'pokeapi-cache',
  MONGO_URL: buildMongoUrl()
}

function buildMongoUrl(){
  //mongodb://[username:password@]host1[:port1][,host2[:port2],...[,hostN[:portN]]][/[database][?options]]
  var str = 'mongodb://'
  if( MONGO_USER && MONGO_PASS )
    str += `${MONGO_USER}:${MONGO_PASS}@`
  str += MONGO_HOST
  if( MONGO_PORT )
    str += `:${MONGO_PORT}`
  str += `/${MONGO_DB}`
  return str
}