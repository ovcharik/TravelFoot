ApplicationController = require './application'
config = require '../../../config'
#Place = require '../../models/place'


class BufferController extends ApplicationController
  
  index:->
    json={}
    errors=[]
    @types=config.get("types")
    error = true
    json.success = true
    
    #if not filters
    for t in @types
      if @request.param(t.name)=="on"
        error = false
        
    if (error==true)
      json.success=false
      errors.push 'Filter is not selected'
    
    #if not radius
    radius=@request.param("Radius")
    expr = new RegExp('[^0-9]+')
    if radius==undefined || radius.trim()==''|| expr.test(radius)
      json.success=false
      errors.push 'Encorrect radius'
      
    json.errors = errors
    if errors.length==0
      #Place.bufferSearch(@request.query)
      Place.bufferSearch {Radius:250, Start:[62.403739, 55.166943], End:[61.403739, 54.453], place:on}, (results) =>
        json.results = results
        @response.json (json)
        @next()
    else
      @response.json (json)
      @next()
    return false
  
  create:->
    return true

module.exports = BufferController
