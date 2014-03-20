global.BaseAbility = require './base'

abilities = require_dir __dirname, {
  nameFun: (name) ->
    name.capitalize() + 'Ability'
  
  except: ['index.js', 'index.coffee', 'base.coffee', 'base.js']
}

for key, value of abilities
  global[key] = value

module.exports = abilities
