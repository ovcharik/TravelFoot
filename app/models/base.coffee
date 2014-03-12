Mongoose = require 'mongoose'

class BaseModel extends Module
  @ObjectId = Mongoose.Schema.ObjectId
  @Mixed    = Mongoose.Schema.Mixed
  
  @_init: ->
    _initVirtualAttributes.apply @
    
    _initValidators.apply @
    _initMethodValidators.apply @
  
  
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
      when "regexp"
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
  
  
  # method validators
  _createMethodValidators = ->
    @_methodValidators = {}
  
  _getMethodValidator = (name) ->
    if not @_methodValidators[name]
      @_methodValidators[name] = []
    @_methodValidators[name]
  
  _addMethodValidator = (name, method, message) ->
    if not @_methodValidators
      _createMethodValidators.apply @
    validator = _getMethodValidator.apply @, [name]
    validator.push [method, message]
  
  _initMethodValidators = ->
    return if not @_methodValidators
    for field, values of @_methodValidators
      path = @schema.path(field)
      throw "Create validator: Can't find path '#{field}' for '#{@modelName}' model" if not path
      for value in values
        fn  = @::[value[0]]
        msg = value[1]
        path.validate fn, msg
  
  @validate: (field, method, message) ->
    _addMethodValidator.apply @, [field, method, message]
  
  
  # virtual attributes
  _createVirtualAttrs = ->
    @_virtualAttrs = []
  
  _addVirtualAttr = (attr) ->
    if not @_virtualAttrs
      _createVirtualAttrs.apply @
    if typeof(attr) != "string"
      throw "Virtual attr must be define as string"
    @_virtualAttrs.push attr
  
  _initVirtualAttributes = ->
    return if not @_virtualAttrs
    for attr in @_virtualAttrs
      _defineVirtualAttr.apply @, [attr]
  
  _defineVirtualAttr = (attr) ->
    @schema.virtual(attr).get(() ->
      return @["#{attr}"]
    ).set((value) ->
      @["#{attr}"] = value
    )
  
  @virtualAttribute: (attr) ->
    _addVirtualAttr.apply @, [attr]
  
  @virtualAttributes: (attrs) ->
    if not (attrs instanceof Array)
      attrs = [attrs]
    for attr in attrs
      _addVirtualAttr.apply @, [attr]
  
module.exports = BaseModel
