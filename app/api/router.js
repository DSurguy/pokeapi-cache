var apiRouter = require('express').Router();
var MongoClient = require('mongodb').MongoClient;
var pokeapiRouter = require('./pokeapi.js');

var mdb;
console.log("Beginning API init...");
//create a mongo connection
MongoClient.connect(require('../config.json').mongo.url).then(function (db){
  mdb = db;

  //generic json body parsing middleware
  // apiRouter.use(function(req, res, next){
  //   var data = "";
  //   req.on('data', (chunk) => { data += chunk});
  //   req.on('end', () => {
  //     console.log(req);
  //     if( (req.get('Content-Type')||'').indexOf('application/json') !== -1 ){
  //       try{
  //         req.body = JSON.parse(data);
  //         next();
  //       }
  //       catch (e){
  //         res.sendStatus(400).end();
  //       }
  //     }
  //     else{
  //       res.sendStatus(400).end();
  //     }
  //   });
  // });

  apiRouter.use('*', function (req, res, next){
    //inject the connection into every api route
    req.db = mdb;
    next();
  });

  apiRouter.use(pokeapiRouter);

  console.log("Completed API init");
})
.catch(function (err){
  console.log(err);
});

module.exports = apiRouter;