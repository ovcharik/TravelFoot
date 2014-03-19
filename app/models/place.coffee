class Place extends BaseModel
  
  @name = 'Place'
  @schema = {
    name:        { type: String, required: true },
    description: { type: String },
    coord:       { type: [Number], index: '2dsphere', required: true },
    kind:        { type: String, enum: ['sight', 'place', 'religion', 'culture'] },
    
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
  
  @getKinds: ->
    @schema.path('kind').enumValues
  
  @bufferSearch: (query, callback) ->
    points = Polygon.createFromTwoPointAndRadiusDeg query.start, query.end, query.radius
    options = {
      kind : { $in: query.kinds },
      coord: { $geoWithin: { $geometry: { type: "Polygon", coordinates: [points] } } }
    }
    @find(options).populate(['tags', 'owner']).exec (err, values) =>
      callback err, values, points

module.exports = Place
