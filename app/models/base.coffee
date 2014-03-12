Mongoose = require 'mongoose'

class BaseModel extends Module
  @ObjectId = Mongoose.Schema.ObjectId
  
  @_init: ->
    _initValidators.apply @
  
  
  # validation
  _createValidators = ->
    @_validators = {}
  
  _getValidator = (name) ->
    if not @_validators[name]
      @_validators[name] = {}
    @_validators[name]
  
  _addValidator = (name, options) ->
    if not @_validators
      _createValidators.apply @
    validator = _getValidator.apply @, [name]
    _.extend validator, options
  
  _initValidators = ->
    return if not @_validators
    for field, values of @_validators
      path = @schema.path(field)
      throw "Create validator: Can't find path '#{field}' for '#{@modelName}' model" if not path
      for validator, value of values
        msg = undefined
        if value instanceof Array
          msg = value[1]
          value = value[0]
        _createValidator.apply @, [path, validator, value, msg]
  
  _createValidator = (path, name, value, msg) ->
    switch name
      when "regex"
        path.validate ((v) ->
          value.test v
        ), (msg || 'regex')
      when "min"
        path.validate ((v) ->
          v >= value
        ), (msg || 'min')
      when "max"
        path.validate ((v) ->
          v <= value
        ), (msg || 'max')
      when "minLength"
        path.validate ((v) ->
          v.length >= value
        ), (msg || 'minLength')
      when "maxLength"
        path.validate ((v) ->
          v.length <= value
        ), (msg || 'maxLength')
      when "required"
        path.required value, (msg || 'required')
      when "unique"
        if value == true
          model = @
          path.validate ((v, respond) ->
            query = { $and: [{_id: {$ne: @_id}}] }
            target = {}
            target[path.path] = @[path.path]
            query.$and.push target
            model.findOne query, ((respond) ->
              (err, m) ->
                respond(!m)
            )(respond)
            return
          ), (msg || "not unique")
  
  @validates: (field, options) ->
    _addValidator.apply @, [field, options]
  
  safeSave: (cb) ->
    @save cb
  
module.exports = BaseModel
