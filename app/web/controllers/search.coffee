ApplicationController = require './application'

class SearchController extends ApplicationController
  
  defaultRadius: 0.5
  
  buffer:->
    kinds  = @params.kinds || Place.getKinds()
    radius = Number @params.radius || @defaultRadius
    start  = [(Number @params.start[0]), (Number @params.start[1])]
    end    = [(Number @params.end[0]), (Number @params.end[1])]
    path   = @params.path
    
    Place.bufferSearch {
      radius: radius,
      start:  start,
      end:    end,
      kinds:  kinds,
      path:   path
    }, (err, results, polygon) =>
      @response.json {
        models: results,
        polygon: polygon
      }
      @next()
    return false

module.exports = SearchController
