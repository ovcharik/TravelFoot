class Ability
  
  _abilities: { }
  
  can: (actions, models, options) ->
    if actions instanceof String
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
