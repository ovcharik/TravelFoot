
	class Converter
		@sphericalToDecart: (point)->
			result=[]
			result[0]= ( Math.sin(point[1]*(Math.PI/180))*Math.cos(point[0]*(Math.PI/180))*6371 )
			result[1]=( Math.sin(point[1]*(Math.PI/180))*Math.sin(point[0]*(Math.PI/180))*6371 )
			result[2]=( Math.cos(point[1]*(Math.PI/180))*6371 )
			return result
		
		@decartToSpherical: (point)->
			result=[]
			result[0]= ( Math.atan(point[1]/point[0]) )*(180/Math.PI)
			result[1]= ( Math.acos(point[2]/ (Math.sqrt(point[0]*point[0]+point[1]*point[1]+point[2]*point[2]) )) )*(180/Math.PI)
			return result

module.exports = Converter