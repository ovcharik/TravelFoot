fs = require 'fs'

helpers = {}

for helper in fs.readdirSync(__dirname).remove(['index.coffee']) when helper.match(/(\.(coffee|js)|view)$/)
  helper = helper.replace(/\.(coffee|js)/, '')
  helpers[helper.capitalize() + 'Helper'] = require "./#{helper}"

for key, value of helpers
  global[key] = value

module.exports = helpers
