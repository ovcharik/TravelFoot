ApplicationController = require './application'

class RegistrationsController extends ApplicationController
  @include AuthHelper
  
  index: ->
    @title = "Sign up"
    return true
  
  create: ->
    user = @request.body.user
    errors = {}
    if user.password != user.confirm
      errors.confirm = {type: 'not matched'}
    
    if not errors.length
      User.create {
        email: user.email,
        password: user.password
      }, (err, user) =>
        json = {}
        if err
          if err.name == "MongoError" and err.code == 11000
            errors.email = {type: 'already exists'}
          else if err.name == "ValidationError"
            errors = err.errors
          else
            errors.base = {type: 'internal unknow error'}
          json.success = false
          json.errors  = errors
        else if user
          json.success = true
          @signin user
        @response.json json
        @next()
      return false
    else
      @response.json {
        success: false,
        errors : errors
      }
    
    return true

module.exports = RegistrationsController
