define ['models/sight', 'collections/search'], (Sight, SearchCollection) ->
  class SearchCollection extends Backbone.Collection
    
    params: undefined
    action: undefined
    
    url: ->
      "/search/#{@action}?#{@params}"
