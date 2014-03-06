class Place
  
  @name = 'Place'
  @schema = {
    name: { type: String, required: true },
    discription: { type: String},
    coord: { type: [Number], index: '2d', required: true },
    image: { type: String }
  }
  
module.exports = Place
