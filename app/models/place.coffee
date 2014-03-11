class Place
  
  @name = 'Place'
  @schema = {
    name:   { type: String, required: true },
    discr:  { type: String },
    coord:  { type: [Number], index: '2d', required: true },
    type:   { type: String, required: true },
    images: [{
      url: { type: String }
    }]
  }
  
module.exports = Place
