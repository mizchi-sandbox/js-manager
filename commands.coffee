#!/usr/bin/env node
require('coffee-script');
doc = require('./doc').doc
fs = require 'fs'
path = require 'path'
request = require('request')

HOME = process.env['HOME']
JSPM_PATH = path.join( HOME , '.javascript_modules')

resource_fname = 'resources'
resources = require('./'+ resource_fname).resources
if path.existsSync( path.join(JSPM_PATH,resource_fname )
  user_resources = require(path.join(JSPM_PATH,resource_fname )).resources
  for k,v of user_resources
    resources[k] = v

goto = (fpath,fn)->
  path.exists fpath,(result)->
    unless result then fs.mkdirSync(fpath,'0777')
    fn()

save = (url,package_name)->
  fname = path.basename(url)
  request uri:url,encoding:'binary', (error, response, body)->
    fs.writeFile path.join(JSPM_PATH,package_name,fname) , body, 'binary', (err)->
      console.log 'saved as '+fname

get_dirfiles = (package_name)->
  if package_name
    return fs.readdirSync path.join JSPM_PATH,package_name
  return fs.readdirSync path.join JSPM_PATH

exports.jspm_commands =
  help:(target)->
    if target
      console.log doc[target]
    else
      console.log doc.jspm
      console.log "[commands]"
      console.log " - #{i}" for i of @

  installed: (package_name)->
    if package_name
      installed_ver =  get_dirfiles(package_name)
      console.log (if path.basename(url) in installed_ver then "* "+ver else ver) for ver, url of resources[package_name]
    else
      console.log "* #{i}" for i in get_dirfiles()

  search: (query)->
    for package_name, url of resources
      if package_name.search(query) >= 0 then console.log (if package_name in get_dirfiles() then "* " else "")+ package_name

  versions: (package_name)->
    console.log "[package] #{package_name}"
    console.log " - #{ver}" for ver,url of resources[package_name]

  install: (target)->
    package_name =  target.split('@')[0]
    package_version =  target.split('@')[1] or 'latest'

    console.log "fetching #{package_name}@#{package_version}"
    if resources[package_name][package_version]
      goto JSPM_PATH,->
        goto path.join(JSPM_PATH,package_name) , ->
          save resources[package_name][package_version], target
    else
      console.log "no such a version"
