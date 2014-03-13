
function getAngle(start, end){
	return  Math.atan((end[1]-start[1])/(end[0]-start[0]));
}

function getSqr(val){
	return val*val;
}

function getLength(point1, point0){
	return Math.sqrt(	getSqr(point1[0]-point0[0]) + getSqr(point1[1]-point0[1]) );
}

function getVector(point1, point0, radius, angle){
		return [radius/getLength(point1, point0)*( (point1[1]-point0[1])*Math.cos(angle)+(point1[0]-point0[0])*Math.sin(angle)),
			radius/getLength(point1, point0)*( (point1[1]-point0[1])*Math.sin(angle)-(point1[0]-point0[0])*Math.cos(angle)),
		]
}

function getDelta(start, end, radius,callback){
	var l = getAngle(start, end);
	var b;
	
	if(l<0){
		b = 2*Math.PI-Math.PI/2-Math.abs(l);
	} else{
		b = 2*Math.PI-Math.PI/2+(l);
	}
	var p=[];
	p[0]=(start[1]>end[1]&&l>0||l<0&&start[1]<end[1]||(start[0]>end[0]&&start[1]==end[1]))?Math.cos(b)*radius:-Math.cos(b)*radius;
	p[1]=(start[1]>end[1]&&l>0||l<0&&start[1]<end[1]||(start[0]>end[0]&&start[1]==end[1]))?Math.sin(b)*radius:-Math.sin(b)*radius;
	callback(p);
	
}
	
function getArcPoints(st, start, end, radius,callback){
		var polygon=[];
		polygon.push(st.p1);
		for (var i = 0; i<Math.PI; i=i+Math.PI/4){
			var point = getVector(start, end, radius, i)
			polygon.push( [point[0]+start[0], point[1]+start[1]] );
		}
		polygon.push(st.p2);
		callback(polygon);
}

function createPolygon(start, end, radius, callback){
	var polygon=[];
	var deltaPoint=[];
	var st={};
	var en={};
	
	getDelta(start, end, radius, function(res){
		deltaPoint=res;
		st={p1:[start[0]+deltaPoint[0], start[1]+deltaPoint[1]],p2:[start[0]-deltaPoint[0], start[1]-deltaPoint[1]]};
		en={p1:[end[0]-deltaPoint[0], end[1]-deltaPoint[1]],p2:[end[0]+deltaPoint[0], end[1]+deltaPoint[1]]};

		getArcPoints(st, start, end, radius, function(res){
			polygon=polygon.concat(res);
			getArcPoints(en, end, start, radius, function(res){
				callback(polygon=polygon.concat(res));
			});
		});
	})
}

module.exports = createPolygon;
