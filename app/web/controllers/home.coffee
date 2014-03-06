ApplicationController = require './application'
config = require '../../../config'

class HomeController extends ApplicationController
  
  index: ->
    @title = "Home"
    @types = config.get("types")
    return true

module.exports = HomeController
