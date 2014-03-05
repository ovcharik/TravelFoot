module.exports = require_dir __dirname, {
  packing: (object, loaded) ->
    _.extend object, loaded
}
