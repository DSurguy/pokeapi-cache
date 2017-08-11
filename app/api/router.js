var apiRouter = require('express').Router();
var MongoClient = require('mongodb').MongoClient;

//create a mongo connection and inject it into every api route
var mdb;
console.log("Beginning API init...");
MongoClient.connect(require('../config.json').mongo.url).then(function (db){
    mdb = db;
    apiRouter.use('*', function (req, res, next){
        req.db = mdb;
        next();
    });

    apiRouter.get('/pokeapi/*', function (req, res){
        console.log("Handling path");
        try{
            req.db.collection('paths').insertOne({
                path: req.path
            }).then(function (){
                res.sendStatus(200);
            }).catch(function (err){
                console.error(err);
                res.sendStatus(500);
            });
        } catch (e){
            console.error(e);

            res.sendStatus(500);
        }
    });

    console.log("Completed API init");
})
.catch(function (err){
    console.log(err);
});

module.exports = apiRouter;