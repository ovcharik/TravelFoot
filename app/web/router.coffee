class Router
  
  constructor: (express, controllers) ->
    @controllers = controllers
    @express = express
    @routes  = require './routes.json'
  
  configure: ->
    for key, value of @routes
      @express[value.method] key, @route.bind(@)
  
  route: (req, res) ->
    path = req.route.path
    route = @routes[path]
    controller = @controllers[route.controller] if route
    if route and controller
      new controller route.action, req, res

module.exports = Router
