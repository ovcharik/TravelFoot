ApplicationController = require './application'

class HomeController extends ApplicationController
  @beforeFilter 'test'
  @afterFilter  'test'
  
  index: ->
    @title = "Главная"
  
  # filters
  test: ->
    console.log 'test'

module.exports = HomeController
