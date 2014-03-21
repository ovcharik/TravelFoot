define ['text!templates/search/marker.haml', 'views/search/map'], (marker_tpl, MapView) ->
  class MapView extends Backbone.View
    
    el: "#gmap"
    
    icons: {
      start: '/images/markers/start.png',
      end  : '/images/markers/end.png'
    }
    
    mapOptions: {
      zoom:   12,
      center: new google.maps.LatLng(55.1745331, 61.426680799999986)
    }
    
    routeStates: {
      start: false,
      end:   false
    }
    
    markerZIndex: 0
    
    initialize: (options) ->
      @collection = options.collection
      @markerTemplate = Haml marker_tpl
      
      @initGmap()
      @bindEvents()
    
    run: ->
      return
    
    bindEvents: ->
      @collection.on 'sync', @updateMarkers, @
      google.maps.event.addListener @gmap, 'click', (point) =>
        @updateRoute(point)
    
    initGmap: ->
      @gmap = new google.maps.Map(@$el[0], @mapOptions) if not @gmap
      @dirService = new google.maps.DirectionsService() if not @dirService
      @dirDisplay = new google.maps.DirectionsRenderer() if not @dirDisplay
      @dirDisplay.setMap(@gmap)
    
    
    # event handlers
    clearMarkers: ->
      if @markers
        for m in @markers
          google.maps.event.clearListeners m
          m.setMap null
        @markerZIndex = 0
    
    updateMarkers: ->
      @clearMarkers()
      
      @markers = []
      @collection.each (sight) =>
        coord = sight.get('coord')
        marker = new google.maps.Marker {
          position: new google.maps.LatLng(coord[1], coord[0]),
          map: @gmap,
          title: sight.get('name'),
          zIndex: @markerZIndex
        }
        
        wnd = new google.maps.InfoWindow {
          content: @markerTemplate { sight: sight }
        }
        google.maps.event.addListener marker, 'click', ((wnd, map, marker) =>
          =>
            wnd.open map, marker
        )(wnd, @gmap, marker)
        @markers.push marker
        sight.marker = marker
        @markerZIndex += 1
    
    onMarker: (sight) ->
      if sight and sight.marker
        @markerZIndex += 1
        marker = sight.marker
        marker.setAnimation(google.maps.Animation.BOUNCE)
        setTimeout (->
          marker.setAnimation(null)
        ), 1500
        @gmap.panTo marker.getPosition()
        @gmap.setZoom 14
        marker.setZIndex @markerZIndex
    
    updateRoute: (point) ->
      s = @routeStates
      if s.start and s.end
        s.start.setMap null if s.start.setMap
        s.end.setMap null if s.end.setMap
        s.start = s.end = false
        
        @dirDisplay.setMap null
        @polygon.setMap null
        @clearMarkers()
      else if s.start and not s.end
        s.end = new google.maps.Marker {
          position: point.latLng,
          icon: @icons.end
          map: @gmap
          title: "End"
        }
        @updateDirection()
        @trigger 'change_route', 'end', [point.latLng.lng(), point.latLng.lat()]
      else if not s.start and not s.end
        s.start = new google.maps.Marker {
          position: point.latLng,
          icon: @icons.start
          map: @gmap
          title: "Start"
        }
        @trigger 'change_route', 'start', [point.latLng.lng(), point.latLng.lat()]
    
    setDirection: (start, end) ->
      start = new google.maps.LatLng(start[1], start[0])
      end   = new google.maps.LatLng(end[1], end[0])
      @updateDirection start, end
    
    updateDirection: (start, end) ->
      s = start || (@routeStates.start && @routeStates.start.get('position'))
      e = end   || (@routeStates.end   && @routeStates.end.get('position'))
      
      if s and e
        @dirService.route {
          origin     : s,
          destination: e,
          travelMode : google.maps.TravelMode.WALKING
        }, (result, status) =>
          if status == google.maps.DirectionsStatus.OK
            @dirDisplay.setDirections result
            @dirDisplay.setMap @gmap
            
            @routeStates.start.setMap(null) if @routeStates.start
            @routeStates.end.setMap(null)   if @routeStates.end
            @routeStates.start = true
            @routeStates.end = true
    
    drawPolygon: (points) ->
      if @polygon
        @polygon.setMap null
      
      coords = []
      for point in points
        coords.push new google.maps.LatLng(point[1], point[0])
      
      options = {
        paths: coords,
        strokeColor: '#FF0000',
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: '#FF0000',
        fillOpacity: 0.35
      }
      
      @polygon = new google.maps.Polygon options
      @polygon.setMap @gmap
