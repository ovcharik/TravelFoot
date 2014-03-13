# deg - координаты в градусах
# rad - координаты в радианах
# dec - координаты в декартовой системе
# flat - плоские координаты
class Converter
  # sphPoints: array of points
  # point is array of type [lng, lat]
  constructor: (sphPoints) ->
    if not (sphPoints[0] instanceof Array)
      sphPoints = [sphPoints]
    
    count = sphPoints.length
    decPoints = @deg2dec(sphPoints)
    
    x = 0
    y = 0
    z = 0
    for p in decPoints
      x += p[0]
      y += p[1]
      z += p[2]
    
    x /= count
    y /= count
    z /= count
    
    @normal = (new Math.Vector3 [x, y, z])
    
    baseZ = @normal.normal()
    baseX = (new Math.Vector3 [0, 1, 0]).mul(baseZ)
    baseY = (new Math.Vector3 [1, 0, 0]).mul(baseZ)
    
    @base = (new Math.Matrix3 [
      baseX.to_a(),
      baseY.to_a(),
      baseZ.to_a()
    ]).trans()
    @baseI = @base.inverse()
    
    @normalFlat = new Math.Vector3 @baseI.mul(@normal).trans().to_a()[0]
    @z = @normalFlat.to_a()[2]
    
    @flatPoints = @dec2flat(decPoints)
  
  deg2rad: (degPoints) ->
    radPoints = new Array(degPoints.length)
    for q, i in degPoints
      for q, j in degPoints[i]
        radPoints[i] = new Array(2) if not radPoints[i]
        radPoints[i][j] = Math.deg2rad degPoints[i][j]
    radPoints
  
  rad2deg: (radPoints) ->
    degPoints = new Array(radPoints.length)
    for q, i in radPoints
      for q, j in radPoints[i]
        degPoints[i] = new Array(2) if not degPoints[i]
        degPoints[i][j] = Math.rad2deg radPoints[i][j]
    degPoints
  
  rad2dec: (radPoints) ->
    decPoints = new Array(radPoints.length)
    for q, i in radPoints
      decPoints[i] = Math.sph2dec radPoints[i]
  
  dec2rad: (decPoints) ->
    radPoints = new Array(decPoints.length)
    for q, i in radPoints
      radPoints[i] = Math.dec2sph decPoints[i]
  
  deg2dec: (degPoints) ->
    decPoints = new Array(degPoints.length)
    radPoints = new Array(degPoints.length)
    for q, i in degPoints
      for q, j in degPoints[i]
        radPoints[i] = new Array(2) if not radPoints[i]
        radPoints[i][j] = Math.deg2rad degPoints[i][j]
      decPoints[i] = Math.sph2dec radPoints[i]
    decPoints
  
  dec2deg: (decPoints) ->
    radPoints = new Array(decPoints.length)
    degPoints = new Array(decPoints.length)
    for q, i in decPoints
      radPoints[i] = Math.dec2sph decPoints[i]
      for q, j in radPoints[i]
        degPoints[i] = new Array(2) if not degPoints[i]
        degPoints[i][j] = Math.rad2deg radPoints[i][j]
      degPoints[i].splice(2, 1)
    degPoints
  
  dec2flat: (decPoints) ->
    flat = new Array(decPoints.length)
    for q, i in decPoints
      flat[i] = new Array(2) if not flat[i]
      flat[i] = @baseI.mul(new Math.Vector3 decPoints[i]).trans().to_a()[0].slice(0, 2)
    flat
  
  deg2flat: (degPoints) ->
    @dec2flat @deg2dec degPoints
  
  flat2dec: (flat) ->
    vPoints = new Array(flat.length)
    for q, i in flat
      for q, j in flat[i]
        vPoints[i] = new Array(3) if not vPoints[i]
        vPoints[i][j] = flat[i][j]
      vPoints[i][2] = @z
    
    decPoints = new Array(vPoints.length)
    for q, i in vPoints
      decPoints[i] = new Array(2) if not decPoints[i]
      decPoints[i] = @base.mul(new Math.Vector3 vPoints[i]).trans().to_a()[0]
    decPoints
  
  flat2deg: (flat) ->
    @dec2deg @flat2dec flat
  
  # main methods
  
  # преобразуем градусы в плоские точки
  toFlat: (deg) ->
    @deg2flat deg
  
  # преобразуем плоские точки в градусы
  fromFlat: (flat) ->
    @flat2deg flat
  
  # получение плоских точек из которых инициализировался массив
  getFlat: ->
    @flatPoints

module.exports = Converter
