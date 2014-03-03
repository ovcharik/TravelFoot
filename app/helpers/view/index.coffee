fs = require 'fs'

module.exports = {}

for view in fs.readdirSync(__dirname).remove(['index.coffee']) when view.match(/\.(coffee|js)$/)
  view = view.replace(/\.coffee/, '')
  view = require ("./#{view}")
  _.extend module.exports, view
