"use strict";
var express = require('express');
var path = require('path');
var app = express();

app.use(express.static(path.join(__dirname, '../test-client')));

app.use(require('./api/router.js'));

app.listen(8080, function (){
  console.log('Listening on port 8080')
});