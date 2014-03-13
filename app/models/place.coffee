BaseModel = require ('./base')
Converter = require ('../../libs/converter')
polygon = require ('../helpers/buffer')
config = require ('../../config')
mongoose = require ('mongoose')

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
  				
  @bufferSearch: (query)->
    types=[]
    for t in config.get("types")
      if query.hasOwnProperty(t.name)
        types.push t.name
    #conv = new Converter([query.Start, query.End])
    #polygon conv.getFlat()[0], conv.getFlat()[1], query.Radius, (poly)=>
    @where('kind').in(types)
      

module.exports = Place
