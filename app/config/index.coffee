nconf  = require 'nconf'

file = if process.env.NODE_ENV? then process.env.NODE_ENV.toLowerCase() else 'development'
nconf.argv().env().file file: "./config/environments/#{file}.json"

module.exports = nconf
