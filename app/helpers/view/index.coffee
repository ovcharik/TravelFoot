fs = require 'fs'

ViewHelper = {}
views = _.map fs.readdirSync(__dirname), (view) ->
  view = view.replace(/\.coffee/, '')

for view in views when view != 'index'
  view = require ("./#{view}")
  _.extend ViewHelper, view

module.exports = ViewHelper
