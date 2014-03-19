ApplicationController = require './application'

class SearchController extends ApplicationController
  
  defaultRadius: 300
  
  buffer:->
    kinds  = @params.kinds || Place.getKinds()
    radius = Number @params.radius || @defaultRadius
    
    console.log @params
    
    Place.bufferSearch {
      radius: radius,
      start:  [64.152,54.132],
      end:    [52.34,31.215],
      kinds:  kinds
    }, (err, results, polygon) =>
      @response.json results
      @next()
    return false

module.exports = SearchController
