ApplicationHelper =
  
  findCurrentUser: ->
    if @request.cookies.email and @request.cookies.password
      user = {
        email: @request.cookies.email
        password: @request.cookies.password
      }
      User.findOne user, (err, user) =>
        @setCurrentUser user if not err and user
        @next()
      return false
    return true
  
  setCurrentUser: (user) ->
    @currentUser = user
    @signedIn = true
  
module.exports = ApplicationHelper
