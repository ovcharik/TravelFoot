define [
  'collections/search',
  'views/search/map',
  'views/search/search'
], (SearchCollection, MapView, SearchView) ->
  
  class SearchView extends Backbone.View
    
    initialize: ->
      @mapView = new MapView
      @collection = new SearchCollection
