define ['text!templates/search/item.haml', 'views/search/results'], (item_tpl, ResultsView) ->
  class ResultsView extends Backbone.View
    
    el: "#results"
    tab: "a[href='#results']"
    list: "#results-list"
    more: "#results-more"
    total: "#results-total"
    
    perPage: 20
    
    initialize: (options) ->
      @collection = options.collection
      
      @$tab = $(@tab)
      @$list = $(@list)
      @$more = $(@more)
      @$total = $(@total)
      
      @itemTemplate = Haml(item_tpl)
      
      @clear()
      @bindEvents()
      return
    
    run: ->
      return
    
    bindEvents: ->
      @collection.on 'sync', @collectionSync, @
      
      @$list.on 'mouseenter', '.result-item', (event) =>
        @trigger 'item_mouseenter', @collection.get($(event.target).attr('data-id'))
      @$list.on 'mouseleave', '.result-item', (event) =>
        @trigger 'item_mouseleave', @collection.get($(event.target).attr('data-id'))
      
      @$more.on 'click', =>
        @render()
    
    show: ->
      @$tab.tab('show')
    
    clear: ->
      @$list.html('')
      @$more.hide()
      @last = 0
    
    render: ->
      start = @last * @perPage
      end   = start + @perPage
      @last += 1
      
      if end > @collection.length
        end = @collection.length
      if end == @collection.length
        @$more.hide()
      else
        @$more.show()
      
      i = start
      while i < end
        model = @collection.models[i]
        model.$html = $(@itemTemplate({ sight: model }))
        @$list.append model.$html
        i++
    
    collectionSync: ->
      @show()
      @clear()
      @render()
      
      @$total.html @collection.length
