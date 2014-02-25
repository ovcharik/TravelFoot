global._ = require 'underscore'

# dependencies
SocketIO      = require 'socket.io'
Express       = require 'express'
ExpressCoffee = require 'express-coffee'
ExpressLess   = require 'express-less'
Http          = require 'http'

# app requie
Socket = require './app/socket'

config = require './config'
logger = require './app/logger'

# configuire server
@server =
  express: Express()
  config:  config
  logger:  logger(config.get('logs:path'), config.get('logs:console'))

# create http
@server.http = Http.createServer(@server.express)

# create websokets
@server.io = SocketIO.listen(@server.http)
@server.io.set 'logger', _.object ([i, @server.logger[i]] for i in ['debug', 'error', 'warn', 'info'])
@server.io.on  'connection', (socket) =>
  new App(@server, socket)

# setup express
@server.express.use ExpressCoffee { path: __dirname + config.get('web:public') }
@server.express.use '/css', ExpressLess(__dirname + config.get('web:less'), { compress: process.env.PRODUCTION })
@server.express.use Express.errorHandler()
@server.express.use Express.static(__dirname + config.get('web:public'))

@server.express.set 'view engine', 'jade'

# start
@server.http.listen config.get('server:port')
