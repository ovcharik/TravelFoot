helpers = require_dir __dirname, {
  nameFun: (name) ->
    name.capitalize() + 'Helper'
}

helpers['ViewHelper'] = require './view'

for key, value of helpers
  global[key] = value

module.exports = helpers
