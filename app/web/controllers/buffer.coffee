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
      #json.results = Place.bufferSearch(@request.param)
    json.results=Place.bufferSearch({Radius:50, Start:[64.152,54.132], End:[52.34,31.215], Sight:on})
			
  @next
		
#send json
    @response.json (json)
    return false
			
  create:->		
    return true
		
module.exports = BufferController
		

	