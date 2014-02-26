ApplicationController = require './application'

class SessionsController extends ApplicationController
  @include AuthHelper
  
  create: ->
    user = @request.body.user
    remember = user.remember
    if user
      User.findOne {
        email: user.email,
        password: user.password
      }, (err, user) =>
        if not err and user
          @signin(user, remember)
          @response.json { success: true }
        else
          @response.json { success: false }
        @next()
      return false
    return true
  
  destroy: ->
    @signout()
    @response.redirect '/'

module.exports = SessionsController
