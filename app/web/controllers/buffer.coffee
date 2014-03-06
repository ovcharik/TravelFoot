ApplicationController = require './application'
config = require '../../../config'

class BufferController extends ApplicationController
	index:->
		@types = config.get("types")
		answer="I get url: ";
		answer += " "+ @request.url
		answer += "<br> And i get "
		for t in @types
			answer += " "+t.name+"="+ @request.param(t.name)
		answer += " Radius="+ @request.param("Radius")
		@response.send(200, answer)
		return true
		
	create:->		
		return true
		
module.exports = BufferController
		

	