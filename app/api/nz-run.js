var nzRunRouter = require('express').Router();

nzRunRouter.post('/nuzlocke/run', function (req, res, next){
  if( !req.body.description || typeof req.body.description !== 'string' ){
    res.status(400).end();
  }
  else if( !req.body.game || typeof req.body.game !== 'string' ){
    res.status(400).end();
  }
  else{
    next();
  }
}, function (req, res){
  res.send({message: 'Correctly Formed Request'});
});

module.exports = nzRunRouter;