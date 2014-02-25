winston = require 'winston'

module.exports = (path, console=false) ->
  winston.remove winston.transports.Console
  winston.add winston.transports.File, filename: path, level: 'debug'
  winston.add winston.transports.Console, level: 'debug' if console
  winston
