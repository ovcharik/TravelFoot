# options:
#   nameFun - function returning object name
#   except  - array of file will be except
#   filter  - regex for filenames

defaultOptions =
  nameFun: (name) ->
    return name
  
  except: ['index.js', 'index.coffee']
  filter: /\.(js|coffee)$/

fs   = require 'fs'
path = require 'path'

module.exports = (path, options) ->
  options ||= {}
  options = _.extend {}, defaultOptions, options
  
  result = {}
  
  files = fs.readdirSync(path).remove(options.except)
  for file in files
    continue if not file.match(options.filter)
    name = options.nameFun file.replace /\.[0-9a-z]+$/i, ''
    result[name] = require "#{path}/#{file}"
  
  return result
