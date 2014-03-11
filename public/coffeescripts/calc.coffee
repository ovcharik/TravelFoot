Math.EARTH_RADIUS = 3150

Math.rad2deg = (a) ->
  a / Math.PI * 180

Math.deg2rad = (a) ->
  a / 180 * Math.PI

Math.sph2dec = (a, b, r) ->
  if a instanceof Array
    b = a[1]
    r = a[2]
    a = a[0]
  else if typeof(a) == "object"
    b = a.b
    r = a.r
    a = a.a
  r ||= Math.EARTH_RADIUS
  [
    r * Math.sin(a) * Math.cos(b),
    r * Math.sin(a) * Math.sin(b),
    r * Math.cos(a)
  ]

Math.dec2sph = (x, y, z) ->
  if x instanceof Array
    y = x[1]
    z = x[2]
    x = x[0]
  else if typeof(x) == "object"
    y = x.y
    z = x.z
    x = x.x
  [
    Math.atan(Math.sqrt(x*x + y*y) / z),
    Math.PI / 2 - Math.atan(x/y),
    Math.sqrt(x*x + y*y + z*z)
  ]


class Math.Matrix3
  constructor: (value) ->
    if value instanceof Math.Vector3
      @value = [value.to_a()]
    else
      @value = value
    @rows = @value.length
    @columns = @value[0].length
  
  det: ->
    throw "error: rows: #{@rows}, columns: #{@columns}" if @rows != @columns
    throw "error: det for only matrix 1x1 or 2x2 or 3x3" if @rows != 3 && @rows != 2 && @rows != 1
    v = @value
    if @rows == 1
      v[0][0]
    else if @rows == 2
      v[0][0]*v[1][1] - v[0][1]*v[1][0]
    else if @rows == 3
      v[0][0]*v[1][1]*v[2][2] + v[0][1]*v[1][2]*v[2][0] + v[0][2]*v[1][0]*v[2][1] - v[0][0]*v[1][2]*v[2][1] - v[0][1]*v[1][0]*v[2][2] - v[0][2]*v[1][1]*v[2][0]
  
  trans: ->
    a = new Array(@columns)
    for i of @value
      for j of @value[i]
        a[j] = new Array(@rows) if not a[j]
        a[j][i] = @value[i][j]
    new Math.Matrix3 a
  
  minor: (x, y) ->
    a = new Array(@rows - 1)
    for i of @value when i != y
      _i = if (i < y) then i else i - 1
      for j of @value[i] when j != x
        _j = if (j < x) then j else j - 1
        a[_i] = new Array(@columns - 1) if not a[_i]
        a[_i][_j] = @value[i][j]
    (new Math.Matrix3 a).det()
  
  minorMatrix: ->
    a = new Array(@rows)
    for i of @value
      for j of @value[i]
        a[i] = new Array(@columns) if not a[i]
        a[i][j] = @minor(i, j)
    new Math.Matrix3 a
  
  cofactor: ->
    a = new Array(@rows)
    for i of @value
      for j of @value[i]
        a[i] = new Array(@columns) if not a[i]
        s = if ((Number(i) + Number(j) + 2) % 2) == 0 then 1 else -1
        a[i][j] = @minor(i, j) * s
    new Math.Matrix3 a
  
  inverse: ->
    d = @det()
    c = @cofactor()
    c.mul(1 / d)
  
  mul: (v) ->
    if (v instanceof Math.Vector3)
      v = new Math.Matrix3(v).trans()
    
    a = new Array(@rows)
    if (v instanceof Math.Matrix3)
      if @columns != v.rows
        console.error "error: can't mul matrix", @, v
        throw "stop"
      for i of @value
        for j of v.value[i]
          s = 0
          for k of @value[i]
            s += @value[i][k] * v.value[k][j]
          a[i] = new Array(v.columns) if not a[i]
          a[i][j] = s
    else if (typeof(v) == "number")
      for i of @value
        for j of @value[i]
          a[i] = new Array(@rows) if not a[i]
          a[i][j] = @value[i][j] * v
    else
      console.error "error: can't mul values", @, v
      throw "stop"
    
    new Math.Matrix3 a
  
  to_a: ->
    @value


class Math.Vector3
  constructor: (value) ->
    if not (value instanceof Array)
      @value = [
        value.x,
        value.y,
        value.z
      ]
    else
      @value = value
  
  mul: (v) ->
    if (v instanceof Math.Matrix3)
      @to_matrix().trans().mul(v)
    else if (v instanceof Math.Vector3)
      new Math.Vector3([
        (new Math.Matrix3([[1, 0, 0], @value, v.value])).det(),
        (new Math.Matrix3([[0, 1, 0], @value, v.value])).det(),
        (new Math.Matrix3([[0, 0, 1], @value, v.value])).det()
      ])
    else
      console.error "error: can't mul values", @, v
      throw "stop"
  
  mod: ->
    s = 0
    for i in @value
      s += i*i
    Math.sqrt s
  
  normal: ->
    a = new Array(@value.length)
    m = @mod()
    for i of @value
      a[i] = @value[i] / m
    new Math.Vector3 a
  
  to_a: ->
    @value
  to_matrix: ->
    new Math.Matrix3(@)


# deg - координаты в градусах
# rad - координаты в радианах
# dec - координаты в декартовой системе
# flat - плоские координаты
class Converter
  # sphPoints: array of points
  # point is array of type [lng, lat]
  constructor: (sphPoints) ->
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
    for i of degPoints
      for j of degPoints[i]
        radPoints[i] = new Array(2) if not radPoints[i]
        radPoints[i][j] = Math.deg2rad degPoints[i][j]
    radPoints
  
  rad2deg: (radPoints) ->
    degPoints = new Array(radPoints.length)
    for i of radPoints
      for j of radPoints[i]
        degPoints[i] = new Array(2) if not degPoints[i]
        degPoints[i][j] = Math.rad2deg radPoints[i][j]
    degPoints
  
  rad2dec: (radPoints) ->
    decPoints = new Array(radPoints.length)
    for i of radPoints
      decPoints[i] = Math.sph2dec radPoints[i]
  
  dec2rad: (decPoints) ->
    radPoints = new Array(decPoints.length)
    for i of radPoints
      radPoints[i] = Math.dec2sph decPoints[i]
  
  deg2dec: (degPoints) ->
    decPoints = new Array(degPoints.length)
    radPoints = new Array(degPoints.length)
    for i of degPoints
      for j of degPoints[i]
        radPoints[i] = new Array(2) if not radPoints[i]
        radPoints[i][j] = Math.deg2rad degPoints[i][j]
      decPoints[i] = Math.sph2dec radPoints[i]
    decPoints
  
  dec2deg: (decPoints) ->
    radPoints = new Array(decPoints.length)
    degPoints = new Array(decPoints.length)
    for i of decPoints
      radPoints[i] = Math.dec2sph decPoints[i]
      for j of radPoints[i]
        degPoints[i] = new Array(2) if not degPoints[i]
        degPoints[i][j] = Math.rad2deg radPoints[i][j]
      degPoints[i].splice(2, 1)
    degPoints
  
  dec2flat: (decPoints) ->
    flat = new Array(decPoints.length)
    for i of decPoints
      flat[i] = new Array(2) if not flat[i]
      flat[i] = @baseI.mul(new Math.Vector3 decPoints[i]).trans().to_a()[0].slice(0, 2)
    flat
  
  deg2flat: (degPoints) ->
    @dec2flat @deg2dec degPoints
  
  flat2dec: (flat) ->
    vPoints = new Array(flat.length)
    for i of flat
      for j of flat[i]
        vPoints[i] = new Array(3) if not vPoints[i]
        vPoints[i][j] = flat[i][j]
      vPoints[i][2] = @z
    
    decPoints = new Array(vPoints.length)
    for i of vPoints
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


$ ->
  $("#calc").click ->
    lng1 = Number $("#lng1").val()
    lat1 = Number $("#lat1").val()
    lng2 = Number $("#lng2").val()
    lat2 = Number $("#lat2").val()
    
    points = [
      [lng1, lat1],
      [lng2, lat2]
    ]
    
    c = new Converter points
    
    console.log "Первоначальные точки", points
    console.log "Конвертер", c
    
    f = c.getFlat()
    console.log "Точки перекастовынные туда обратно", c.fromFlat(f)
