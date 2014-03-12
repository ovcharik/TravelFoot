global.BaseModel = require './base'

module.exports = require_dir __dirname, {
  nameFun: (name) ->
    name.capitalize()
  
  except: ['index.js', 'index.coffee', 'base.coffee', 'base.js']
}
