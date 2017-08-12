var apiRouter = require('express').Router();
var MongoClient = require('mongodb').MongoClient;
var nzCache = require('./nzCache.js');

var mdb;
console.log("Beginning API init...");
//create a mongo connection
MongoClient.connect(require('../config.json').mongo.url).then(function (db){
    mdb = db;
    apiRouter.use('*', function (req, res, next){
        //inject the connection into every api route
        req.db = mdb;
        //also inject our nzCache
        req.nzCache = new nzCache();
        next();
    });

    //pokeapi image routes
    apiRouter.get('/pokeapi/*.png', function (req, res){
        console.log(`Image path: ${req.path.replace('/pokeapi','')}`);
        res.sendStatus(200);
    });

    apiRouter.get('/pokeapi/*', function (req, res){
        req.nzCache.jData(req.path.replace(/\/?pokeapi/,''), req.db)
        .then(function (data){
            res.status(200).send(data);
        }).catch(function (err){
            res.status(500).end();
            console.error(err);
        });
    });

    console.log("Completed API init");
})
.catch(function (err){
    console.log(err);
});

module.exports = apiRouter;