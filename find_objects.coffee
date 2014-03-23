_    = require 'underscore'
HTTP = require 'http'
URL  = require 'url'

Mongoose = require 'mongoose'
findOrCreate = require 'mongoose-findorcreate'

requestOptions = {
  protocol: "http",
  hostname: "psearch-maps.yandex.ru",
  port:     80,
  pathname: "/1.x/"
}

requestQuery = {
  format:  "json",
  results: "100",
  ll:      "61.407778,55.160556",
  spn:     "0.5,0.5",
  rspn:    "1"
}

queries = {
  sight: [
    "памятник",
    "фонтан"
  ],
  place: [
    "парк"
  ],
  religion: [
    "мечеть",
    "церковь",
    "синагога"
  ],
  culture: [
    "музей",
    "театр"
  ]
}

Schema   = Mongoose.Schema
ObjectId = Schema.ObjectId

userSchema = new Schema {
  email:    { type: String, required: true, unique: true },
  password: { type: String, required: true }
}

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
    url: { type: String }
  }],
  
  owner: { type: ObjectId, ref: 'User' }
  tags:  [{ type: ObjectId, ref: 'Tag' }]
}

tagSchema = new Schema {
  value:  { type: String, required: true, unique: true }
  places: [{ type: ObjectId, ref: 'Place', unique: true }]
}

placeSchema.plugin findOrCreate
userSchema.plugin findOrCreate
tagSchema.plugin findOrCreate

Place = Mongoose.model 'Place', placeSchema
User  = Mongoose.model 'User', userSchema
Tag   = Mongoose.model 'Tag', tagSchema


# functions
querySearch = (queryStr, callback) ->
  options = _.clone requestOptions
  options.query = _.clone requestQuery
  options.query.text = queryStr
  
  url = URL.format options
  console.log url
  
  HTTP.get url, (res) =>
    res.setEncoding 'utf8'
    body = ""
    res.on 'data', (data) ->
      body += data
    res.on 'end', ->
      json = JSON.parse body
      if json.error
        console.log "Error:", queryStr, json.error
      else
        callback json.response.GeoObjectCollection.featureMember

findObjectsStack = 0
findObjects = (group, word) ->
  findObjectsStack += 1
  querySearch word, (objects) ->
    for object in objects when object["GeoObject"]
      newPlace object["GeoObject"], group, word
    findObjectsStack -= 1
    if findObjectsStack == 0
      saveBuffers()

newPlace = (ya, kind, query) ->
  p = {}
  tags = [query]
  if ya["metaDataProperty"] and ya["metaDataProperty"]["PSearchObjectMetaData"] 
    if ya["metaDataProperty"]["PSearchObjectMetaData"]["Address"]
      addr = ya["metaDataProperty"]["PSearchObjectMetaData"]["Address"]
      p.address = {}
      p.address.city   = addr["locality"]      if addr["locality"]
      p.address.street = addr["thoroughfare"]  if addr["thoroughfare"]
      p.address.house  = addr["premiseNumber"] if addr["premiseNumber"]
    if ya["metaDataProperty"]["PSearchObjectMetaData"]["Tags"]
      p.tags = []
      for tag in ya["metaDataProperty"]["PSearchObjectMetaData"]["Tags"] when tag.tag?
        tags.push tag.tag
  
  p.description = ya["description"] if ya["description"]
  p.name = ya["name"]
  p.coord = ya["Point"]["pos"].split(" ")
  p.kind = kind
  
  place = new Place(p)
  addPlace place, tags


globalOwner = undefined
placesBuffer = []
addPlace = (place, tags) ->
  p = new Place place
  for t in tags
    tag = getTag(t)
    tag.places.push p._id
    p.tags.push tag._id
  p.owner = globalOwner._id if globalOwner
  placesBuffer.push p
  

tagsBuffer = {}
getTag = (tag) ->
  if tagsBuffer[tag]
    tagsBuffer[tag]
  else
    t = new Tag { value: tag, places: [] }
    tagsBuffer[tag] = t
    t

saveBuffers = ->
  c = 0
  for p in placesBuffer
    c += 1
    p.save (err, p) ->
      c -= 1
      throw err if err
      console.log p
      if c == 0
        printInfo()
  for i, t of tagsBuffer
    c += 1
    t.save (err, t) ->
      c -= 1
      throw err if err
      console.log t
      if c == 0
        printInfo()

printInfo = ->
  console.log "Count of places: #{placesBuffer.length}\n"
  console.log "Tags:"
  counter = 0
  for i, v of tagsBuffer
    counter++
    console.log "\t#{counter}: #{i}"
  console.log "done"
  Mongoose.connection.close()

# main
Mongoose.connect 'mongodb://localhost/travel_foot', (err) ->
  throw err if err
  
  User.findOrCreate { email: "system" }, { email: "system", password: "ph06ahyoVble" }, (err, user) ->
    throw err if err
    console.log user
    
    globalOwner = user
    
    for group, words of queries
      for word in words
        findObjects group, word
