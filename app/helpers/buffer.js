
//this function returns array of points on line between two points (start and end). Distance between points  -  radius.
getPoints = function(start, end, radius){
	var points=[];
	//distance 
	function dist(st, en){
		return Math.sqrt((end.x-point.x)*(end.x-point.x)+(end.y-point.y)*(end.y-point.y));
	}
	//get next point on line
	function getPoint(start, end, radius){	
		var k = (end.y-start.y)/(end.x-start.x); //calculate angle's index
		var l = Math.atan(k);
		l=(l>0)?l-Math.PI:l;	 
		var xd = Math.cos(l)*radius;
		var yd = Math.sin(l)*radius;

		if ((start.y>end.y)||(start.y==end.y && start.x<end.x)){   
			return {x:start.x+xd, y:start.y+yd}
		}else {
			return {x:start.x-xd, y:start.y-yd}; 
		};
	}
	
	var point = {x:start.x, y:start.y};
	points.push(point);			//push start point
	while(dist(point, end)>=radius){	//while point not end 
		point = getPoint(point, end, radius);	//get next point on line
		points.push(point);			//add point in array
	};
	points.push(end);			//push end point

	return points;
}

module.exports = getPoints;
