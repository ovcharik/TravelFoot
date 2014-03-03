underscore = require 'underscore'

require './string'
require './array'

module.exports = {
  _     : underscore
  Module: require './module'
}

for key, value of module.exports
  global[key] = value
