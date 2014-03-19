define ['models/sight', 'collections/search'], (Sight, SearchCollection) ->
  class SearchCollection extends Backbone.Collection
    
    model: Sight
    
    params: undefined
    action: undefined
    
    url: ->
      "/search/#{@action}?#{@params}"
