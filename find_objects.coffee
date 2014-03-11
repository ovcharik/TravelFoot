_    = require 'underscore'
HTTP = require 'http'
URL  = require 'url'

Mongoose = require 'mongoose'

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
    "парк",
    "кладбище"
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

Place = Mongoose.model 'Place', new Schema {
  name:   { type: String, required: true },
  coord:  { type: [Number], index: '2d', required: true },
  group:  { type: String },
  query:  { type: String },
  images: [{
    url: { type: String }
  }],
  tags:   [{ type: ObjectId, ref: 'Tag' }]
}

Tag = Mongoose.model 'Tag', new Schema {
  value:  { type: String, required: true, unique: true }
  places: [{ type: ObjectId, ref: 'Place', unique: true }]
}


querySearch = (queryStr, callback) ->
  options = _.clone requestOptions
  options.query = _.clone requestQuery
  options.query.text = queryStr
  
  url = URL.format options
  
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

findObjects = (group, word) ->
  querySearch word, (objects) ->
    console.log group, word, objects.length


Mongoose.connect 'mongodb://localhost/travel_foot', (err) ->
  throw err if err
  
  for group, words of queries
    for word in words
      findObjects group, word
      break
    break
