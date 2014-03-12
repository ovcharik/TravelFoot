_    = require 'underscore'
HTTP = require 'http'
URL  = require 'url'
IM   = require 'imagemagick'
FS   = require 'fs'

Mongoose = require 'mongoose'

publicPath = __dirname + '/public'

Schema   = Mongoose.Schema
ObjectId = Schema.ObjectId

placeSchema = new Schema {
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
  
  owner: { type: ObjectId, ref: 'User' }
  tags:  [{ type: ObjectId, ref: 'Tag' }]
}

Place = Mongoose.model 'Place', placeSchema

Mongoose.connect 'mongodb://localhost/travel_foot', (err) ->
  throw err if err
  
  Place.find (err, places) ->
    throw err if err
    
    c = 0
    for place in places
      c += 1
      images = _.filter place.images, (image) ->
        FS.existsSync("#{publicPath}/#{image.url}.#{image.ext}")
      place.images = images
      place.save (err) ->
        throw err if err
        c -= 1
        if c == 0
          Mongoose.connection.close()
          console.log "done"
