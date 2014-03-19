define ['views/search/filters'], (FiltersView) ->
  class FiltersView extends Backbone.View
    
    el: "#search-form"
    
    initialize: (options) ->
      @collection = options.collection
      
      @$start = [
        $("#start-0"),
        $("#start-1")
      ]
      @$end = [
        $("#end-0"),
        $("#end-1")
      ]
      
      @bindEvents()
      @submit()
    
    bindEvents: ->
      @$el.on 'submit', =>
        @onSubmit()
        return false
    
    onSubmit: ->
      params = @$el.serialize()
      action = 'buffer'
      
      @collection.params = params
      @collection.action = action
      
      @collection.fetch()
    
    submit: ->
      @$el.trigger 'submit'
    
    changeRoute: (name, point) ->
      if name == 'start'
        @$start[0].val point[0]
        @$start[1].val point[1]
        @$end[0].val point[0]
        @$end[1].val point[1]
      else
        @$end[0].val point[0]
        @$end[1].val point[1]
      @submit()
