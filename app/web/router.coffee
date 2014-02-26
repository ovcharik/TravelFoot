class Router
  
  constructor: (express, controllers) ->
    @controllers = controllers
    @express = express
    @routes  = require './routes.json'
  
  configure: ->
    for key, value of @routes
      if value instanceof Array
        for v in value
          @express[v.method] key, @route.bind(@)
      else
        @express[value.method] key, @route.bind(@)
  
  route: (req, res) ->
    path = req.route.path
    route = @routes[path]
    if route
      if route instanceof Array
        method = req.route.method
        routes = route
        route  = false
        for r in routes when not route and r.method == method
          route = r
      controller = @controllers[route.controller] if route
      new controller route.action, req, res if controller

module.exports = Router
