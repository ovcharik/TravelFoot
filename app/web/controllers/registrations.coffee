ApplicationController = require './application'

class RegistrationsController extends ApplicationController
  @include AuthHelper
  
  index: ->
    @title = "Sign up"
    return true
  
  create: ->
    user = @request.body.user
    errors = []
    if not user.email
      errors.push [ 'email', 'is required' ]
    else if not user.email.match /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/
      errors.push [ 'email', 'not matched' ]
    
    if not user.password
      errors.push [ 'password', 'is required' ]
    else if user.password != user.confirm
      errors.push [ 'confirm', 'not matched' ]
    
    if not errors.length
      User.create {
        email: user.email,
        password: user.password
      }, (err, user) =>
        json = {}
        if err
          if err.code == 11000
            errors.push [ 'email', 'already exist' ]
          else
            errors.push [ 'base', 'internal unknow error' ]
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
