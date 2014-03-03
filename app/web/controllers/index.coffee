fs = require 'fs'

module.exports = {}

files = fs.readdirSync(__dirname).remove ['index.coffee', 'base.coffee']
for file in files when file.match(/\.(coffee|js)$/)
  file = file.replace /\.(coffee|js)/, ''
  module.exports[file] = require "./#{file}"
