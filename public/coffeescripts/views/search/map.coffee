define ['views/search/map'], (MapView) ->
  class MapView extends Backbone.View
    
    el: "#gmap"
    
    mapOptions: {
      zoom:   12,
      center: new google.maps.LatLng(55.1745331, 61.426680799999986)
    }
    
    initialize: (options) ->
      @gmap = undefined
      @initGmap()
    
    initGmap: ->
      @gmap = new google.maps.Map(@$el[0], @mapOptions)
    
    drawPolygon: (points) ->
      if @polygon
        @polygon.setMap null
      
      coords = []
      for point in points
        coords.push new google.maps.LatLng(point[1], point[0])
      
      options: {
        paths: coords,
        strokeColor: '#FF0000',
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: '#FF0000',
        fillOpacity: 0.35
      }
      
      @polygon = new google.maps.Polygon options
      @polygon.setMap(map)
