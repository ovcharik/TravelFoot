fs = require 'fs'

module.exports = {}

files = fs.readdirSync(__dirname).remove ['index.coffee', 'base.coffee']
for file in files
  file = file.replace /\.(coffee|js)/, ''
  module.exports[file.capitalize()] = require "./#{file}"
