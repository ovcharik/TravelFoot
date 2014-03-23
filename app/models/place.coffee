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
  
  formatedAddress: ->
    addr = [@address.city, @address.street, @address.house]
    _.compact(addr).join(", ")
  
  @getKinds: ->
    @schema.path('kind').enumValues
  
  @bufferSearch: (query, callback) ->
    points = []
    if query.path
      points = Polygon.createFromPathDeg query.path, query.radius, true
    else
      points = Polygon.createFromTwoPointAndRadiusDeg query.start, query.end, query.radius, true
    options = {
      kind : { $in: query.kinds },
      coord: { $geoWithin: { $geometry: { type: "Polygon", coordinates: [points] } } }
    }
    @find(options).populate(['tags', 'owner']).exec (err, values) =>
      callback err, values, points

module.exports = Place
