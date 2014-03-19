ApplicationController = require './application'

class BufferController extends ApplicationController
  
  defaultRadius: 300
  
  index:->
    kinds  = @params.kinds || Place.getKinds()
    radius = Number @params.radius || @defaultRadius
    
    Place.bufferSearch {
      radius: radius,
      start:  [64.152,54.132],
      end:    [52.34,31.215],
      kinds:  kinds
    }, (err, results) =>
      @response.json {
        results: results,
        error:  err
      }
      @next()
    return false
  
  create:->
    return true

module.exports = BufferController
