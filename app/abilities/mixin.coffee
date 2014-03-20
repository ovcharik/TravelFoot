MixinAbility =
  
  can: (action, model) ->
    @_initAbility() if not @_ability
    @_ability.check action, model
  
  _initAbility: ->
    @_initClass() if not @_class
    _abilityClass = eval @_class.abilityName
    @_ability = new _abilityClass(@)
  
  _initClass: ->
    @_class = @constructor

module.exports = MixinAbility
