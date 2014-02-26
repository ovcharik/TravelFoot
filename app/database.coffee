class Database
  
  Mongoose: require 'mongoose'
  
  constructor: (@server) ->
    host = @server.config.get 'database:host'
    user = @server.config.get 'database:user'
    pwd  = @server.config.get 'database:pwd'
    db   = @server.config.get 'database:database'
    auth = if user? or pwd? then "#{user}:#{pwd}@" else ''
    
    @Mongoose.connect "mongodb://#{auth}#{host}/#{db}"
    @connection = @Mongoose.connection
    
    @connection.once 'open', @initModels.bind(@)
  
  initModels: ->
    
    @models = require './models'
    
    for key, value of @models
      @models[key] = @Mongoose.model(value.name, @Mongoose.Schema(value.schema))
      global[key] = @models[key]
  
module.exports = Database
