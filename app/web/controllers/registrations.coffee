ApplicationController = require './application'

class RegistrationsController extends ApplicationController
  @include AuthHelper
  
  index: ->
    @title = "Sign up"
    return true
  
  create: ->
    User.create @request.body.user, (err, user) =>
      json = {}
      errors = undefined
      if err
        if err.name == "ValidationError"
          errors = err.errors
        else
          errors.base = {message: 'internal unknow error'}
        json.success = false
        json.errors  = errors
      else if user
        json.success = true
        @signin user
      @response.json json
      @next()
    return false

module.exports = RegistrationsController
