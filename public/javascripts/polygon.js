
  $(function() {
    var canvas, ctx, height, width;
    canvas = $("#canvas")[0];
    ctx = canvas.getContext('2d');
    width = canvas.width;
    height = canvas.height;
    return window.drawPoints = function(points) {
      var point, x0, y0, _i, _len;
      ctx.fillStyle = "white";
      ctx.fillRect(0, 0, width, height);
      x0 = width / 2;
      y0 = height / 2;
      console.log(x0, y0);
      ctx.strokeStyle = "black";
      ctx.lineWidth = 1;
      ctx.beginPath();
      ctx.moveTo(x0 + points[0][0], y0 + points[0][1]);
      for (_i = 0, _len = points.length; _i < _len; _i++) {
        point = points[_i];
        ctx.lineTo(x0 + point[0], y0 + point[1]);
      }
      ctx.closePath();
      return ctx.stroke();
    };
  });
