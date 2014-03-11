(function() {
  var Converter;

  Math.EARTH_RADIUS = 3150;

  Math.rad2deg = function(a) {
    return a / Math.PI * 180;
  };

  Math.deg2rad = function(a) {
    return a / 180 * Math.PI;
  };

  Math.sph2dec = function(a, b, r) {
    if (a instanceof Array) {
      b = a[1];
      r = a[2];
      a = a[0];
    } else if (typeof a === "object") {
      b = a.b;
      r = a.r;
      a = a.a;
    }
    r || (r = Math.EARTH_RADIUS);
    return [r * Math.sin(a) * Math.cos(b), r * Math.sin(a) * Math.sin(b), r * Math.cos(a)];
  };

  Math.dec2sph = function(x, y, z) {
    if (x instanceof Array) {
      y = x[1];
      z = x[2];
      x = x[0];
    } else if (typeof x === "object") {
      y = x.y;
      z = x.z;
      x = x.x;
    }
    return [Math.atan(Math.sqrt(x * x + y * y) / z), Math.PI / 2 - Math.atan(x / y), Math.sqrt(x * x + y * y + z * z)];
  };

  Math.Matrix3 = (function() {

    function Matrix3(value) {
      if (value instanceof Math.Vector3) {
        this.value = [value.to_a()];
      } else {
        this.value = value;
      }
      this.rows = this.value.length;
      this.columns = this.value[0].length;
    }

    Matrix3.prototype.det = function() {
      var v;
      if (this.rows !== this.columns) {
        throw "error: rows: " + this.rows + ", columns: " + this.columns;
      }
      if (this.rows !== 3 && this.rows !== 2 && this.rows !== 1) {
        throw "error: det for only matrix 1x1 or 2x2 or 3x3";
      }
      v = this.value;
      if (this.rows === 1) {
        return v[0][0];
      } else if (this.rows === 2) {
        return v[0][0] * v[1][1] - v[0][1] * v[1][0];
      } else if (this.rows === 3) {
        return v[0][0] * v[1][1] * v[2][2] + v[0][1] * v[1][2] * v[2][0] + v[0][2] * v[1][0] * v[2][1] - v[0][0] * v[1][2] * v[2][1] - v[0][1] * v[1][0] * v[2][2] - v[0][2] * v[1][1] * v[2][0];
      }
    };

    Matrix3.prototype.trans = function() {
      var a, i, j;
      a = new Array(this.columns);
      for (i in this.value) {
        for (j in this.value[i]) {
          if (!a[j]) a[j] = new Array(this.rows);
          a[j][i] = this.value[i][j];
        }
      }
      return new Math.Matrix3(a);
    };

    Matrix3.prototype.minor = function(x, y) {
      var a, i, j, _i, _j;
      a = new Array(this.rows - 1);
      for (i in this.value) {
        if (!(i !== y)) continue;
        _i = i < y ? i : i - 1;
        for (j in this.value[i]) {
          if (!(j !== x)) continue;
          _j = j < x ? j : j - 1;
          if (!a[_i]) a[_i] = new Array(this.columns - 1);
          a[_i][_j] = this.value[i][j];
        }
      }
      return (new Math.Matrix3(a)).det();
    };

    Matrix3.prototype.minorMatrix = function() {
      var a, i, j;
      a = new Array(this.rows);
      for (i in this.value) {
        for (j in this.value[i]) {
          if (!a[i]) a[i] = new Array(this.columns);
          a[i][j] = this.minor(i, j);
        }
      }
      return new Math.Matrix3(a);
    };

    Matrix3.prototype.cofactor = function() {
      var a, i, j, s;
      a = new Array(this.rows);
      for (i in this.value) {
        for (j in this.value[i]) {
          if (!a[i]) a[i] = new Array(this.columns);
          s = ((Number(i) + Number(j) + 2) % 2) === 0 ? 1 : -1;
          a[i][j] = this.minor(i, j) * s;
        }
      }
      return new Math.Matrix3(a);
    };

    Matrix3.prototype.inverse = function() {
      var c, d;
      d = this.det();
      c = this.cofactor();
      return c.mul(1 / d);
    };

    Matrix3.prototype.mul = function(v) {
      var a, i, j, k, s;
      if (v instanceof Math.Vector3) v = new Math.Matrix3(v).trans();
      a = new Array(this.rows);
      if (v instanceof Math.Matrix3) {
        if (this.columns !== v.rows) {
          console.error("error: can't mul matrix", this, v);
          throw "stop";
        }
        for (i in this.value) {
          for (j in v.value[i]) {
            s = 0;
            for (k in this.value[i]) {
              s += this.value[i][k] * v.value[k][j];
            }
            if (!a[i]) a[i] = new Array(v.columns);
            a[i][j] = s;
          }
        }
      } else if (typeof v === "number") {
        for (i in this.value) {
          for (j in this.value[i]) {
            if (!a[i]) a[i] = new Array(this.rows);
            a[i][j] = this.value[i][j] * v;
          }
        }
      } else {
        console.error("error: can't mul values", this, v);
        throw "stop";
      }
      return new Math.Matrix3(a);
    };

    Matrix3.prototype.to_a = function() {
      return this.value;
    };

    return Matrix3;

  })();

  Math.Vector3 = (function() {

    function Vector3(value) {
      if (!(value instanceof Array)) {
        this.value = [value.x, value.y, value.z];
      } else {
        this.value = value;
      }
    }

    Vector3.prototype.mul = function(v) {
      if (v instanceof Math.Matrix3) {
        return this.to_matrix().trans().mul(v);
      } else if (v instanceof Math.Vector3) {
        return new Math.Vector3([(new Math.Matrix3([[1, 0, 0], this.value, v.value])).det(), (new Math.Matrix3([[0, 1, 0], this.value, v.value])).det(), (new Math.Matrix3([[0, 0, 1], this.value, v.value])).det()]);
      } else {
        console.error("error: can't mul values", this, v);
        throw "stop";
      }
    };

    Vector3.prototype.mod = function() {
      var i, s, _i, _len, _ref;
      s = 0;
      _ref = this.value;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        i = _ref[_i];
        s += i * i;
      }
      return Math.sqrt(s);
    };

    Vector3.prototype.normal = function() {
      var a, i, m;
      a = new Array(this.value.length);
      m = this.mod();
      for (i in this.value) {
        a[i] = this.value[i] / m;
      }
      return new Math.Vector3(a);
    };

    Vector3.prototype.to_a = function() {
      return this.value;
    };

    Vector3.prototype.to_matrix = function() {
      return new Math.Matrix3(this);
    };

    return Vector3;

  })();

  Converter = (function() {

    function Converter(sphPoints) {
      var baseX, baseY, baseZ, count, decPoints, p, x, y, z, _i, _len;
      count = sphPoints.length;
      decPoints = this.deg2dec(sphPoints);
      x = 0;
      y = 0;
      z = 0;
      for (_i = 0, _len = decPoints.length; _i < _len; _i++) {
        p = decPoints[_i];
        x += p[0];
        y += p[1];
        z += p[2];
      }
      x /= count;
      y /= count;
      z /= count;
      this.normal = new Math.Vector3([x, y, z]);
      baseZ = this.normal.normal();
      baseX = (new Math.Vector3([0, 1, 0])).mul(baseZ);
      baseY = (new Math.Vector3([1, 0, 0])).mul(baseZ);
      this.base = (new Math.Matrix3([baseX.to_a(), baseY.to_a(), baseZ.to_a()])).trans();
      this.baseI = this.base.inverse();
      this.normalFlat = new Math.Vector3(this.baseI.mul(this.normal).trans().to_a()[0]);
      this.z = this.normalFlat.to_a()[2];
      this.flatPoints = this.dec2flat(decPoints);
    }

    Converter.prototype.deg2rad = function(degPoints) {
      var i, j, radPoints;
      radPoints = new Array(degPoints.length);
      for (i in degPoints) {
        for (j in degPoints[i]) {
          if (!radPoints[i]) radPoints[i] = new Array(2);
          radPoints[i][j] = Math.deg2rad(degPoints[i][j]);
        }
      }
      return radPoints;
    };

    Converter.prototype.rad2deg = function(radPoints) {
      var degPoints, i, j;
      degPoints = new Array(radPoints.length);
      for (i in radPoints) {
        for (j in radPoints[i]) {
          if (!degPoints[i]) degPoints[i] = new Array(2);
          degPoints[i][j] = Math.rad2deg(radPoints[i][j]);
        }
      }
      return degPoints;
    };

    Converter.prototype.rad2dec = function(radPoints) {
      var decPoints, i, _results;
      decPoints = new Array(radPoints.length);
      _results = [];
      for (i in radPoints) {
        _results.push(decPoints[i] = Math.sph2dec(radPoints[i]));
      }
      return _results;
    };

    Converter.prototype.dec2rad = function(decPoints) {
      var i, radPoints, _results;
      radPoints = new Array(decPoints.length);
      _results = [];
      for (i in radPoints) {
        _results.push(radPoints[i] = Math.dec2sph(decPoints[i]));
      }
      return _results;
    };

    Converter.prototype.deg2dec = function(degPoints) {
      var decPoints, i, j, radPoints;
      decPoints = new Array(degPoints.length);
      radPoints = new Array(degPoints.length);
      for (i in degPoints) {
        for (j in degPoints[i]) {
          if (!radPoints[i]) radPoints[i] = new Array(2);
          radPoints[i][j] = Math.deg2rad(degPoints[i][j]);
        }
        decPoints[i] = Math.sph2dec(radPoints[i]);
      }
      return decPoints;
    };

    Converter.prototype.dec2deg = function(decPoints) {
      var degPoints, i, j, radPoints;
      radPoints = new Array(decPoints.length);
      degPoints = new Array(decPoints.length);
      for (i in decPoints) {
        radPoints[i] = Math.dec2sph(decPoints[i]);
        for (j in radPoints[i]) {
          if (!degPoints[i]) degPoints[i] = new Array(2);
          degPoints[i][j] = Math.rad2deg(radPoints[i][j]);
        }
        degPoints[i].splice(2, 1);
      }
      return degPoints;
    };

    Converter.prototype.dec2flat = function(decPoints) {
      var flat, i;
      flat = new Array(decPoints.length);
      for (i in decPoints) {
        if (!flat[i]) flat[i] = new Array(2);
        flat[i] = this.baseI.mul(new Math.Vector3(decPoints[i])).trans().to_a()[0].slice(0, 2);
      }
      return flat;
    };

    Converter.prototype.deg2flat = function(degPoints) {
      return this.dec2flat(this.deg2dec(degPoints));
    };

    Converter.prototype.flat2dec = function(flat) {
      var decPoints, i, j, vPoints;
      vPoints = new Array(flat.length);
      for (i in flat) {
        for (j in flat[i]) {
          if (!vPoints[i]) vPoints[i] = new Array(3);
          vPoints[i][j] = flat[i][j];
        }
        vPoints[i][2] = this.z;
      }
      decPoints = new Array(vPoints.length);
      for (i in vPoints) {
        if (!decPoints[i]) decPoints[i] = new Array(2);
        decPoints[i] = this.base.mul(new Math.Vector3(vPoints[i])).trans().to_a()[0];
      }
      return decPoints;
    };

    Converter.prototype.flat2deg = function(flat) {
      return this.dec2deg(this.flat2dec(flat));
    };

    Converter.prototype.toFlat = function(deg) {
      return this.deg2flat(deg);
    };

    Converter.prototype.fromFlat = function(flat) {
      return this.flat2deg(flat);
    };

    Converter.prototype.getFlat = function() {
      return this.flatPoints;
    };

    return Converter;

  })();

  $(function() {
    return $("#calc").click(function() {
      var c, f, lat1, lat2, lng1, lng2, points;
      lng1 = Number($("#lng1").val());
      lat1 = Number($("#lat1").val());
      lng2 = Number($("#lng2").val());
      lat2 = Number($("#lat2").val());
      points = [[lng1, lat1], [lng2, lat2]];
      c = new Converter(points);
      console.log("Первоначальные точки", points);
      console.log("Конвертер", c);
      f = c.getFlat();
      return console.log("Точки перекастовынные туда обратно", c.fromFlat(f));
    });
  });

}).call(this);
