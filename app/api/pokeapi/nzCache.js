"use strict";

var http = require('http');

function nzCache(){

}

/* Process and return json data from pokeapi after caching */
nzCache.prototype.jData = function (path, db){
    return new Promise(function (resolve, reject){
        db.collection('dataCache').findOne({
            $or: [
                {'path': path}
            ]
        }).then(function (result){
            var fetchActual = false;
            if( result ){
                //has the expire date passed?
                if( result.expires < process.hrtime() ){
                    resolve(result.data); return;
                }
            }
            //fetch actual
            console.log(`Forwarding to pokeapi: http://pokeapi.co${path}`);
            nodeGet(`http://pokeapi.co${path}`, function (response){
                //cache this response
                db.collection('dataCache').update({
                    $or: [{'path': path}]
                }, {
                    data: response,
                    expires: process.hrtime()
                }, { 
                    upsert: true
                }).then(()=>{
                    //return the data now that it's cached
                    resolve(response); 
                }).catch(function (e){
                    reject(e);
                });
            });
        }).catch (function (err){
            reject(err);
        })
    });
};

/* Process and return image data from pokeapi after caching */
nzCache.prototype.iData = function (path){
    
};

function nodeGet(url, callback){
    http.get(url, (res) => {
        const { statusCode } = res;
        const contentType = res.headers['content-type'];

        let error;
        if (statusCode < 200 || statusCode > 399) {
            error = new Error('Request Failed.\n' +
                            `Status Code: ${statusCode}`);
        } else if (!/^application\/json/.test(contentType)) {
            error = new Error('Invalid content-type.\n' +
                            `Expected application/json but received ${contentType}`);
        }
        if (error) {
            console.error(error);
            // consume response data to free up memory
            res.resume();
            callback(); //send undefined data
        }
        else{
            res.setEncoding('utf8');
            let rawData = '';
            res.on('data', (chunk) => { rawData += chunk; });
            res.on('end', () => {
                try {
                    const parsedData = JSON.parse(rawData);
                    callback(parsedData);
                } catch (e) {
                    console.error(e);
                    callback(); //send undefined data
                }
            });
        }
    }).on('error', (e) => {
        console.error(e);
    });
}

module.exports = nzCache;