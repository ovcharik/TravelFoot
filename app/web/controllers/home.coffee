ApplicationController = require './application'

class HomeController extends ApplicationController
  
  index: ->
    @title = "Home"
    return true

module.exports = HomeController
