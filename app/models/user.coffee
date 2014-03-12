crypto = require 'crypto'

class User extends BaseModel
  
  @name = 'User'
  @schema = {
    email:    { type: String, required: true, unique: true },
    password: { type: String, required: true },
    sessions: [{
      ip:   { type: String },
      ua:   { type: String },
      hash: { type: String },
      live: { type: Boolean, default: true },
      time: { type: Date, default: Date.now }
    }]
  }
  
  @validates 'email',    {regex: [/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/, 'not matched'], require: true, unique: true}
  @validates 'password', {minLength: [3, 'min length is 3'], require: true}
  
  createSession: (request) ->
    md5sum = crypto.createHash('md5')
    md5sum.update(request.ip + @password + Date.now())
    hash = md5sum.digest('hex')
    
    session = {
      ip: request.ip,
      ua: request.headers['user-agent'],
      hash: hash
    }
    
    @sessions.unshift session
    if @sessions.length > 10
      @sessions.pop()
    @save()
    
    return session
  
  checkSession: (request) ->
    token = request.cookies.token
    return false if not token
    session = _.findWhere @sessions, { hash: token, live: true, ip: request.ip }
    
    return true if session
    return false
  
  killSession: (request) ->
    token = request.cookies.token
    flag  = false
    return false if not token
    for session, index in @sessions when not flag and session.hash == token
      @sessions[index].live = false
      flag = true
    if flag
      @save()
    return flag
  
module.exports = User
