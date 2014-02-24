var myMap;
var observers=[];
var marker;
	//Создание карты в myMapId       
	// Создаем обработчик загрузки страницы:

        DG.autoload(function() {
            // Создаем объект карты, связанный с контейнером:
            myMap = new DG.Map('myMapId');
            // Устанавливаем центр карты, и коэффициент масштабирования:
            myMap.setCenter(new DG.GeoPoint(61.407778,55.160556), 15);
            // Добавляем элемент управления коэффициентом масштабирования:
            myMap.controls.add(new DG.Controls.Zoom());
	    myMap.geoclicker.disable();
	    marker = createMarker();
	    findPosition();

        });


	function paintStreet(streets){
		// Создаем объект стилей:
		var style1 = new DG.Style.Geometry();
		var style2 = new DG.Style.Geometry();
		// Устанавливаем значения свойств:
		style1.strokeColor = "red";
		style1.strokeOpacity = 1;
		style1.strokeWidth = 5;

		style2.strokeColor = "blue";
		style2.strokeOpacity = 1;
		style2.strokeWidth = 3;
		
		var myPolyline;
		var points;
		for(var i=0; i<streets.length; i++){
			if (DG.WKTParser.getObjectType(streets[i].selection)=='LINESTRING'){
 				myPolyline = DG.WKTParser.getPolyline(streets[i].selection);
			} else{
				myPolyline = DG.WKTParser.getMultipolyline(streets[i].selection);
			}
			myPolyline.setStyle(style2);
 			myMap.geometries.add(myPolyline);
			var points = myPolyline.getPoints();
 			for(var j=0; j<points.length; j++ ){
  				var myPoint = new DG.Geometries.Point(points[j],style1);
  				myMap.geometries.add(myPoint);
 			}
			
		}
	}

	function paintNearStreet(){
		queryNotSimple(paintStreet, marker.getPosition().getLon()+","+marker.getPosition().getLat(), 'street', 250);		
	}

	function successStreet(result){
		var nearStreet;
		var nearDist = 300;
		for(var i=0; i<result.length; i++){
			if (result[i].dist<nearDist){
				nearStreet=result[i];
				nearDist=result[i].dist;
			}
		}
		alert("Ближайшая улица: " +nearStreet.name);
		alert("расстояние до нее = "+nearDist);
		
	      return nearStreet;
	}

	function findNearStreet(){
		queryNotSimple(successStreet, marker.getPosition().getLon()+","+marker.getPosition().getLat(), 'street', 250);		
		
	}

	function findPosition(){
		if (navigator.geolocation){
			navigator.geolocation.getCurrentPosition(success, failure,{timeout: 10000});
		};
		function success(pos){
			var point = new DG.GeoPoint(pos.coords.longitude,pos.coords.latitude);
			marker.setPosition(point);
			myMap.markers.add(marker);
			myMap.setCenter(point, 15);
			
		};

		function failure(error){
				alert("Ошибка "+error.err+" " +error.message);
		};
	}


	function drawMarkers(result, type){
		if (myMap.markers.getGroup(type)==null) {
			myMap.markers.createGroup(type);}
		else {  
			myMap.markers.getGroup(type).removeAll();
		};
		for (var i=0; i<result.length; i++){
			if (result[i].getName()!=''){
				var marker = result[i].getMarker();	
				marker.setHintContent(result[i].getName());
				myMap.markers.add(marker, type);
			}	
		}	
	}



	function successMarkers(result){
		alert("Обнаружено "+result.length+" объектов");
		drawMarkers(result, 'sight');
		return result;		
	}

	//Запрос данных
	function querySimple(successF, query, type, radius, bound){
		myMap.geocoder.get(query, 
			{types:type, 
			radius:radius, 
			bound:bound, 
			success:successF,
			failure:function(code, error){
				if (code==404){ alert("Объектов не обнаружено");}
				else {alert(error+" " + code);}
			}
	
		});
		
	}



	function createMarker(){	    
		marker=new DG.Markers.Common({geoPoint:new DG.GeoPoint(61.407778,55.160556), hint:"Я здесь"});
		observers[0]=myMap.addEventListener(myMap.getContainerId(), 'DgClick', 
		createPoint=function(eventMouse){
			marker.setPosition(eventMouse.getGeoPoint());			
			myMap.markers.add(marker);
		});
		return marker;
	}	

	function findInAround(){
		querySimple(successMarkers, marker.getPosition(),['sight', 'place'],250);
	}

	function findAll(){
		queryNotSimple(marker.getPosition().getLon().toFixed(6)+","+marker.getPosition().getLat().toFixed(6),
				"sight,place",
				"bound[point1]="+myMap.getBounds().getLeftTop().getLon().toFixed(6)+","+myMap.getBounds().getLeftTop().getLat().toFixed(6)+"&bound[point2]="+myMap.getBounds().getRightBottom().getLon().toFixed(6)+","+myMap.getBounds().getRightBottom().getLat().toFixed(6));
	}

//не хочет работать что-то
	function clear(){
		myMap.markers.removeAll();
		myMap.geometries.removeAll();
		myMap.redraw();
		//myMap.destroy();

	}

	//получение результата запроса в виде json-страницы
	function queryNotSimple(success, query, type, radius){
		var request = new XMLHttpRequest();
		var query = "http://catalog.api.2gis.ru/geo/search?q="+query+"&types="+type+"&radius="+radius+"&version=1.3&key=ruocgd9025";
		request.open("GET", query);
		request.onreadystatechange = function() {
			if (this.readyState == 4) {
				if (this.status == 200) {
					var response = JSON.parse(this.responseText);
					//alert(response.response_code);
					alert("Получено "+response.total+" записей");
					success(response.result);
        			}
				else {
					alert("Ошибка получения данных");
				}
			}
		};
		request.send(null);
	};

