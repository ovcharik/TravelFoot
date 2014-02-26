ApplicationController = require './application'

class HomeController extends ApplicationController
  @beforeFilter 'test'
  @afterFilter  'test'
  
  index: ->
    @title = "Главная"
    return true
  
  # filters
  test: ->
    console.log 'test'
    return true

module.exports = HomeController
