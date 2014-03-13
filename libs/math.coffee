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
    for q, i in @value
      for q, j in @value[i]
        a[j] = new Array(@rows) if not a[j]
        a[j][i] = @value[i][j]
    new Math.Matrix3 a
  
  minor: (x, y) ->
    a = new Array(@rows - 1)
    for q, i in @value when i != y
      _i = if (i < y) then i else (i - 1)
      for q, j in @value[i] when j != x
        _j = if (j < x) then j else j - 1
        a[_i] = new Array(@columns - 1) if not a[_i]
        a[_i][_j] = @value[i][j]
    (new Math.Matrix3 a).det()
  
  minorMatrix: ->
    a = new Array(@rows)
    for q, i in @value
      for q, j in @value[i]
        a[i] = new Array(@columns) if not a[i]
        a[i][j] = @minor(i, j)
    new Math.Matrix3 a
  
  cofactor: ->
    a = new Array(@rows)
    for q, i in @value
      for q, j in @value[i]
        a[i] = new Array(@columns) if not a[i]
        s = if ((i + j + 2) % 2) == 0 then 1 else -1
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
      for q, i in @value
        for q, j in v.value[i]
          s = 0
          for q, k in @value[i]
            s += @value[i][k] * v.value[k][j]
          a[i] = new Array(v.columns) if not a[i]
          a[i][j] = s
    else if (typeof(v) == "number")
      for q, i in @value
        for q, j in @value[i]
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
    for q, i in @value
      a[i] = @value[i] / m
    new Math.Vector3 a
  
  to_a: ->
    @value
  to_matrix: ->
    new Math.Matrix3(@)
