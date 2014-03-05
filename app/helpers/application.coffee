ApplicationHelper =
  
  findCurrentUser: ->
    userId = @request.cookies.user
    token  = @request.cookies.token
    if userId and token
      User.findOne {_id: userId}, (err, user) =>
        if not err and user and user.checkSession(@request)
          @setCurrentUser user
        @next()
      return false
    return true
  
  setCurrentUser: (user) ->
    @currentUser = user
    @signedIn = true
  
module.exports = ApplicationHelper
