define ['views/search/filters'], (FiltersView) ->
  class FiltersView extends Backbone.View
    
    el: "#search-form"
    tab: "a[href='#search']"
    button: "#search-form button[type=submit]"
    
    initialize: (options) ->
      @collection = options.collection
      
      @$button = $(@button)
      
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
      @blockButton()
      
      params = @$el.serializeObject()
      if @path
        params.path = @path
      
      action = 'buffer'
      @collection.action = action
      
      @collection.fetch
        modelsPath: 'models'
        data: params
        success: (collection, resp, options) =>
          @trigger 'update_polygon', resp.polygon
          @unblockButton()
        error: ->
          @unblockButton()
    
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
    
    changePath: (path) ->
      @path = path
      @submit()
    
    blockButton: ->
      @$button.prop 'disabled', true
    
    unblockButton: ->
      @$button.prop 'disabled', false
