var apiRouter = require('express').Router();
var MongoClient = require('mongodb').MongoClient;
var NzCache = require('./nzCache.js');

var NZRUN_STATUS = {
    FAILED: 0,
    IN_PROGRESS: 1,
    SUCCEEDED: 2
};

var mdb;
console.log("Beginning API init...");
//create a mongo connection
MongoClient.connect(require('../config.json').mongo.url).then(function (db){
    mdb = db;

    //generic json body parsing middleware
    apiRouter.use(function(req, res, next){
        var data = "";
        req.on('data', function(chunk){ data += chunk});
        req.on('end', function(){
            if( req.get('Content-Type').indexOf('application/json') !== -1 ){
                try{
                    req.body = JSON.parse(data);
                    next();
                }
                catch (e){
                    res.sendStatus(400).end();
                }
            }
            else{
                res.sendStatus(400).end();
            }
        });
    });

    apiRouter.use('*', function (req, res, next){
        //inject the connection into every api route
        req.db = mdb;
        //also inject our nzCache
        req.nzCache = new NzCache();
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

    apiRouter.post('/nuzlocke/run', function (req, res){
        console.log(req.body);
        res.send({msg: 'YOU GOT IT'});
    });

    console.log("Completed API init");
})
.catch(function (err){
    console.log(err);
});

module.exports = apiRouter;