class BaseAbility
  
  constructor: (model) ->
    @_abilities = {}
    @intitalize(model)
  
  intitalize: ->
    false
  
  check: (action, model) ->
    inst = typeof(model) != 'function'
    act  = @_getAction(action)
    abil = _.find(act, (a) ->
      inst and (model instanceof a.model) or model == a.model
    )
    
    if abil
      if inst and abil.options
        result = true
        for key, value of abil.options
          v = model[key]
          v = v._id || v
          result &&= (value.equals(v))
        return result
      else if abil.options
        return false
      else
        return true
    else
      return false
  
  can: (actions, models, options) ->
    if typeof actions == 'string'
      if actions == "manage"
        actions = ["create", "update", "read", "delete"]
      else
        actions = [actions]
    
    if not (models instanceof Array)
      models = [models]
    
    for model in models
      @_addAbility actions, model, options
  
  _addAbility: (actions, model, options) ->
    if typeof(model) != "function"
      throw "Model is not class"
    for name in actions
      action = @_getAction(name)
      action.push {
        model: model,
        options: options
      }
  
  _getAction: (action) ->
    if not @_abilities[action]
      @_abilities[action] = []
    @_abilities[action]

module.exports = BaseAbility
