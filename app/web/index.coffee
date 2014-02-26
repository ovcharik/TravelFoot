Router      = require './router'
controllers = require './controllers'

class Web
  
  constructor: (@server) ->
    @helpers = @server.helpers
    @router = new Router(@server.express, controllers)
    @router.configure()
  
module.exports = Web
