Router      = require './router'
controllers = require './controllers'

class Web
  
  constructor: (server) ->
    @server = server
    @router = new Router(@server.express, controllers)
    @router.configure()
  
module.exports = Web
