helpers = {
  ApplicationHelper: require './application'
  AuthHelper: require './auth'
}

for key, value of helpers
  global[key] = value

module.exports = helpers
