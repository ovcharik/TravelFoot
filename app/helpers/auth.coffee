AuthHelper =
  
  signin: (user, remember) ->
    options = {}
    if remember
      now = new Date
      now.setDate(now.getDate() + 30)
      options.expires = now
    session = user.createSession(@request)
    @response.cookie 'user', user._id, options
    @response.cookie 'token', session.hash, options
  
  signout: ->
    @currentUser.killSession(@request)
    @response.clearCookie 'user'
    @response.clearCookie 'token'
  
module.exports = AuthHelper
