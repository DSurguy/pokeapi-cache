var pokeapiRouter = require('express').Router();
var NzCache = require('./pokeapi/nzCache.js');

//pokeapi image routes
pokeapiRouter.get('/pokeapi/*.png', function (req, res){
  console.log(`Image path: ${req.path.replace('/pokeapi','')}`);
  res.sendStatus(200);
});

pokeapiRouter.get('/pokeapi/*', function (req, res){
  req.nzCache.jData(req.path.replace(/\/?pokeapi/,''), req.db)
  .then(function (data){
    res.status(200).send(data);
  }).catch(function (err){
    res.status(500).end();
    console.error(err);
  });
});

module.exports = pokeapiRouter;