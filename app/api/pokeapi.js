var pkRouter = require('express').Router();
var pkCache = new (require('./pkCache.js'));

//pokeapi image routes
pkRouter.get('/pokeapi/*.png', function (req, res){
  console.log(`Image path: ${req.path.replace('/pokeapi','')}`);
  res.sendStatus(200);
});

pkRouter.get('/pokeapi/*', function (req, res){
  console.log('Handling /pokeapi/*');
  pkCache.jData(req.path.replace(/\/?pokeapi/,''), req.db)
  .then(function (data){
    res.status(200).send(data);
  }).catch(function (err){
    res.status(500).end();
    console.error(err);
  });
});

module.exports = pkRouter;