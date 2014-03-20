class UserAbility extends BaseAbility
  
  intitalize: (user) ->
    
    if user.isAdmin()
      @can "manage", [Place, User, Tag]
    else
      @can ["create", "read"], [Place, Tag]
      @can ["update", "delete"], Place, { 'owner': user._id }
      
      @can "create", User
      @can ["update", "delete", "read"], User, { '_id': user._id }

module.exports = UserAbility
