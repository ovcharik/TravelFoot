crypto = require 'crypto'

defaultOptions = {
  forceDefault: false,
  rating: 'g',
  size: 80,
  default: 'identicon',
  fileType: false
}

url = "http://www.gravatar.com/avatar/"

module.exports = {
  
  gravatarUrl: (email, options) ->
    
    options ||= {}
    options = _.extend {}, defaultOptions, options
    
    if typeof(email) == "object"
      email = email.email
    email = 'hash' if not email
    md5sum = crypto.createHash('md5')
    md5sum.update(email)
    hash = md5sum.digest('hex')
    
    image = url + hash
    opt = []
    if options.forceDefault
      opt.push "f=y"
    if options.default
      opt.push "d=#{options.default}"
    if options.size
      opt.push "s=#{options.size}"
    if options.rating
      opt.push "r=#{options.rating}"
    
    if options.fileType
      image += options.fileType
    opt = opt.join("&")
    image += "?#{opt}"
    return image
}
