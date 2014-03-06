ApplicationController = require './application'
config = require '../../../config'

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
		
		if radius==undefined || radius.trim()==''
			json.success=false
			errors.push 'Encorrect radius'	
				
		json.errors = errors
		
#get data from model
		#to-do model.getPlaces(@request.query), return results

#send json
		@response.json (json)
		
		@next
		return false
			
	create:->		
		return true
		
module.exports = BufferController
		

	