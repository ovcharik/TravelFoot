AuthHelper =
  
  signin: (user, remember) ->
    options = {}
    if remember
      now = new Date
      now.setDate(now.getDate() + 30)
      options.expires = now
    @response.cookie 'email', user.email, options
    @response.cookie 'password', user.password, options
  
  signout: ->
    @response.clearCookie 'email'
    @response.clearCookie 'password'
  
module.exports = AuthHelper
