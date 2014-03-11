ObjectId = require('mongoose').Schema.ObjectId

class Place
  
  @name = 'Place'
  @schema = {
    name:        { type: String, required: true },
    description: { type: String },
    coord:       { type: [Number], index: '2d', required: true },
    kind:        { type: String },
    
    address: {
      city:   { type: String },
      street: { type: String },
      house:  { type: String }
    },
    
    images: [{
      url: { type: String }
    }],
    
    owner: { type: ObjectId, ref: 'User' }
    tags:  [{ type: ObjectId, ref: 'Tag' }]
  }
  
module.exports = Place
