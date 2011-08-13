#!/usr/bin/env node
var fs = require('fs');
var path = require('path');
require('coffee-script');
var resources = require('./resources').resources;

var HOME = process.env['HOME']
var JSPM_PATH = path.join( HOME , '.javascript_modules')
var JSPM_ROOT = "/jspm/"

exports.createPath = function(application,targets){
    var paths = {};
    targets.forEach(function(target){
        var package_name =  target.split('@')[0]
        var package_version =  target.split('@')[1] || 'latest'
        var abs_path = path.join( 
            JSPM_PATH, 
            package_name,
            path.basename(resources[package_name][package_version]) 
        );
        var app_path = JSPM_ROOT+package_name;
        fs.readFile( abs_path , function(err,data){
            var s = data.toString();
            application.get(app_path,  function(req,  res){
               res.writeHead(200, {'Content-Type': 'text/javascript'});
               res.end( s );
            });
        });

        paths[package_name] = app_path; 
    });
    return paths;
};

exports.setRoot = function(root_path){
    JSPM_ROOT = root_path;
};

