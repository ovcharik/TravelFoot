# dependencies
SocketIO      = require 'socket.io'
Express       = require 'express'
ExpressCoffee = require 'express-coffee'
ExpressLess   = require 'less-middleware'
Http          = require 'http'

libs = require './libs'
helpers = require './app/helpers'

# app requie
Socket   = require './app/socket'
Web      = require './app/web'
Database = require './app/database'

config  = require './config'
logger  = require './app/logger'

# configuire server
@server =
  express:  Express()
  config:   config
  logger:   logger(config.get('logs:path'), config.get('logs:console'))
  helpers:  helpers

# create db
@server.database = new Database @server

# create http
@server.http = Http.createServer(@server.express)

# create websokets
@server.io = SocketIO.listen(@server.http)
@server.io.set 'logger', _.object ([i, @server.logger[i]] for i in ['debug', 'error', 'warn', 'info'])
@server.io.on  'connection', (socket) =>
  new App(@server, socket)

# setup express
@server.express.use ExpressCoffee {
  path: __dirname + config.get('web:public')
}
@server.express.use ExpressLess {
  src : config.get('web:less')
  dest: config.get('web:css')
  root: __dirname + config.get('web:public')
  compress: process.env.PRODUCTION
}

@server.express.use Express.errorHandler()
@server.express.use Express.bodyParser()
@server.express.use Express.methodOverride()
@server.express.use Express.cookieParser()
@server.express.use Express.static(__dirname + config.get('web:public'))

@server.express.set 'view engine', 'jade'
@server.express.set 'views', __dirname + config.get('web:views')
@server.express.locals.basedir = @server.express.get 'views'
_.extend @server.express.locals, helpers.ViewHelper

web = new Web(@server)

# start
@server.http.listen config.get('server:port')
