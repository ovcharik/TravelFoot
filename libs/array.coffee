Array::remove = (value) ->
  if typeof(value) == "string"
    value = [value]
  
  if value instanceof Array
    for i of value
      index = this.indexOf value[i]
      this.splice(index, 1) if index > -1
  @
