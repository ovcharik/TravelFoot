define ['models/typificable_model'], (TypificableModel) ->
  class TypificableModel extends Backbone.Model
    
    super: Backbone.Model.prototype
    rules: {}
    
    initialize: ->
      @.on 'change', =>
        @typification()
    
    set: (attributes, options) ->
      @super.set.call(@, attributes, options)
      @typification()
    
    typification: ->
      for key, fun of @rules
        if @hasChanged(key)
          @attributes[key] = fun(@attributes[key])
    
  return TypificableModel
