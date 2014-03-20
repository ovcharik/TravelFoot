define ['views/search/filters'], (FiltersView) ->
  class FiltersView extends Backbone.View
    
    el: "#search-form"
    tab: "a[href='#search']"
    
    initialize: (options) ->
      @collection = options.collection
      
      @$tab = $(@tab)
      @$start = [
        $("#start-0"),
        $("#start-1")
      ]
      @$end = [
        $("#end-0"),
        $("#end-1")
      ]
      
      @bindEvents()
      return
    
    run: ->
      @submit()
      @trigger 'update_path', [Number(@$start[0].val()), Number(@$start[1].val())], [Number(@$end[0].val()), Number(@$end[1].val())]
    
    show: ->
      @$tab.tab('show')
    
    bindEvents: ->
      @$el.on 'submit', =>
        @onSubmit()
        return false
    
    onSubmit: ->
      params = @$el.serialize()
      action = 'buffer'
      
      @collection.params = params
      @collection.action = action
      
      @collection.fetch
        modelsPath: 'models'
        success: (collection, resp, options) =>
          @trigger 'update_polygon', resp.polygon
    
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
