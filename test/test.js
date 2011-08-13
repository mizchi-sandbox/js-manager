require('coffee-script');
var express = require('express');
var app = express.createServer();
var jspm = require('js-manager');
console.log(jspm);

var paths = jspm.createPath( app, [ 'jquery@1.6.2','mootools' ] );

app.get('/',  function(req,  res){
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end(
        '<html>'+
        '<script src="'+paths.jquery+'"></script>'+
        '<a href="'+ paths.jquery+'">'+paths.jquery+ '</a>'+
        '<a href="'+ paths.mootools+'">'+paths.mootools+'</a>'+
        '</html>');
});

app.listen(3333);
