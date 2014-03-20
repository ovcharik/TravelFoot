define ['models/sight', 'collections/custom_fetch', 'collections/search'], (Sight, CustomFetchCollection, SearchCollection) ->
  class SearchCollection extends CustomFetchCollection
    
    model: Sight
    
    params: undefined
    action: undefined
    
    url: ->
      "/search/#{@action}?#{@params}"
