Mongoose = require 'mongoose'

class BaseModel extends Module
  
  @ObjectId = Mongoose.Schema.ObjectId
  
  @validate: (field, options) ->
    return true
  
  safeSave: (cb) ->
    @save cb
  
module.exports = BaseModel
