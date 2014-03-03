require './string'
require './array'

module.exports = {
  _     : require 'underscore'
  Module: require './module'
}

for key, value of module.exports
  global[key] = value
