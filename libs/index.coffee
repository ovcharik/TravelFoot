global['_'] = require 'underscore'

require './math'
require './string'
require './array'

global['Module']      = require './module'
global['Converter']   = require './converter'
global['Polygon']     = require './polygon'

global['require_dir'] = require './require_dir'
