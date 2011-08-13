#!/usr/bin/env coffee
require('coffee-script')
jspm_commands = require('./../commands').jspm_commands

cmd_type = (if process.argv.length>2 then process.argv[2] else "help")
unless jspm_commands[cmd_type]
  console.log "[#{cmd_type}] no such a command."
  process.exit(0)

jspm_commands[cmd_type] process.argv[3]

