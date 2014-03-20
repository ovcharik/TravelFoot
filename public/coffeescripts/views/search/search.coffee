define [
  'collections/search',
  'views/search/filters',
  'views/search/map',
  'views/search/search'
], (SearchCollection, FiltersView, MapView, SearchView) ->
  
  class SearchView extends Backbone.View
    
    content: {
      main: "#main-columns"
      left: "#main-columns > .left"
      right: "#main-columns > .right"
      tabs: "#main-columns > .left .nav.nav-tabs"
      tabsContent: "#main-columns > .left .tab-content"
    }
    footer: "#footer"
    header: "#header"
    
    initialize: ->
      @collection = new SearchCollection
      
      @mapView = new MapView {
        collection: @collection
      }
      @filtersView = new FiltersView {
        collection: @collection
      }
      
      @$content = {
        $main: $(@content.main),
        $left: $(@content.left),
        $right: $(@content.right),
        $tabs: $(@content.tabs),
        $tabsContent: $(@content.tabsContent)
      }
      
      @$footer = $(@footer)
      @$header = $(@header)
      
      @$window = $(window)
      
      @bindEvents()
      @run()
    
    bindEvents: ->
      @$window.on 'resize', =>
        @onResize()
      
      @mapView.on 'change_route', @filtersView.changeRoute, @filtersView
      
      @filtersView.on 'update_polygon', @mapView.drawPolygon, @mapView
      @filtersView.on 'update_path', @mapView.setDirection, @mapView
    
    run: ->
      @filtersView.run()
      @mapView.run()
      
      @onResize()
    
    onResize: ->
      width = @$window.width()
      if width < 768
        @$content.$main.css { height: "auto" }
        @$content.$right.css { height: "300px", float: "", "margin-bottom": "20px" }
        @$content.$tabsContent.css { height: "auto" }
      else
        height = @$window.height() - @$header.height() - @$footer.height() - 42
        height = 300 if height < 300
        @$content.$main.height(height)
        @$content.$right.css { height: "", float: "right", "margin-bottom": "" }
        
        height = @$content.$left.height() - @$content.$tabs.height()
        @$content.$tabsContent.height(height)
