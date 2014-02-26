ApplicationController = require './application'

class HomeController extends ApplicationController
  
  index: ->
    @title = "Главная"
    return true

module.exports = HomeController
