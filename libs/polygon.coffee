class Polygon
  
  @angle: (start, end) ->
    Math.atan (end[1] - start[1]) / (end[0] - start[0])
  
  @length: (start, end) ->
    Math.sqrt(Math.sqr(end[0] - start[0]) + Math.sqr(end[1] - start[1]))
  
  @arc: (center, radius, start, end, step) ->
    step  ||= Math.PI / 3
    start ||= 0
    end   ||= 2 * Math.PI - step
    
    start = start % (2 * Math.PI)
    end   = end   % (2 * Math.PI)
    
    stepObj = (typeof(step) == 'object')
    if stepObj
      step.angle = Math.abs(step.angle)
    else
      step = Math.abs(step)
    
    end += Math.PI * 2 if start > end
    
    throw "center is required param" if not center
    throw "radius is required param" if not radius
    
    result = []
    
    a = start
    i = 0
    while (not stepObj and a <= end) or (stepObj and i <= step.count)
      result.push [
        center[0] + radius * Math.cos(a),
        center[1] + radius * Math.sin(a),
      ]
      if stepObj
        a += step.angle
        i += 1
      else
        a += step
    
    result
  
  @createFromTwoPointAndRadius: (start, end, radius) ->
    angle = @angle start, end
    
    s = angle + Math.PI / 2
    e = s + Math.PI
    step = {
      angle: Math.abs((e - s) / 3),
      count: 3
    }
    
    if start[0] > end[0]
      start = [start, end]
      end   = start[0]
      start = start[1]
    
    result = []
    if start[0] == end[0] and start[1] == end[1]
      result = @arc start, radius
    else
      lArc = @arc start, radius, s, e, step
      rArc = @arc end,   radius, e, s, step
      
      for p in lArc
        result.push p
      for p in rArc
        result.push p
    
    result.push result[0]
    result
  
  @createFromTwoPointAndRadiusDeg: (start, end, radius) ->
    converter = new Converter([start, end])
    flat = converter.getFlat()
    polygon = @createFromTwoPointAndRadius(flat[0], flat[1], radius)
    converter.fromFlat polygon

module.exports = Polygon
