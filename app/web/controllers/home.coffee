ApplicationController = require './application'

class HomeController extends ApplicationController
  
  index: ->
    @title = "Home"
    @kinds = Place.getKinds()
    return true

module.exports = HomeController
