polygon = require ('../helpers/buffer')
config = require ('../../config')

class Place extends BaseModel
  
  @name = 'Place'
  @schema = {
    name:        { type: String, required: true },
    description: { type: String },
    coord:       { type: [Number], index: '2dsphere', required: true },
    kind:        { type: String },
    
    address: {
      city:   { type: String },
      street: { type: String },
      house:  { type: String }
    },
    
    images: [{
      url: { type: String },
      ext: { type: String }
    }],
    
    owner:  { type: @ObjectId, ref: 'User' },
    editor: { type: @ObjectId, ref: 'User' },
    tags:   [{ type: @ObjectId, ref: 'Tag' }]
  }
  
  @bufferSearch: (query, cb)->
    types=[]
    for t in config.get("types")
      if query.hasOwnProperty(t.name)
        types.push t.name
    conv = new Converter([query.Start, query.End])
    @where('kind').in(types).exec (err, values) =>
      polygon conv.getFlat()[0], conv.getFlat()[1], query.Radius, (values) =>
        cb values

module.exports = Place
