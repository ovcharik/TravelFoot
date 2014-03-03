Array.prototype.remove = function(value) {
  if (typeof(value) === "string") {
    value = [value];
  }
  if (value instanceof Array) {
    for (var i in value) {
      index = this.indexOf(value[i]);
      if (index > -1) {
        this.splice(index, 1);
      }
    }
  }
  return this;
}
