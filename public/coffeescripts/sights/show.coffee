$ ->
  $map = $("#map")
  
  center = new google.maps.LatLng($map.attr('data-lat'), $map.attr('data-lng'))
  map = new google.maps.Map $map[0], {
    zoom: 15,
    center: center
  }
  marker = new google.maps.Marker {
    position: center,
    map: map
  }
