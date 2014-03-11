_    = require 'underscore'
HTTP = require 'http'
URL  = require 'url'
IM   = require 'imagemagick'
FS   = require 'fs'

Mongoose = require 'mongoose'

requestOptions = {
  protocol: "http",
  hostname: "ajax.googleapis.com",
  port:     80,
  pathname: "/ajax/services/search/images"
}

requestQuery = {
  v: "1.0",
}

uploadsPath = __dirname + '/public/uploads'

Schema   = Mongoose.Schema
ObjectId = Schema.ObjectId

placeSchema = new Schema {
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
    url: { type: String },
    ext: { type: String }
  }],
  
  owner: { type: ObjectId, ref: 'User' }
  tags:  [{ type: ObjectId, ref: 'Tag' }]
}

Place = Mongoose.model 'Place', placeSchema

querySearch = (place, callback) ->
  options = _.clone requestOptions
  options.query = _.clone requestQuery
  options.query.q = "Челябинск " + place.name
  
  url = URL.format options
  
  HTTP.get url, (res) =>
    res.setEncoding 'utf8'
    body = ""
    res.on 'data', (data) ->
      body += data
    res.on 'end', ->
      json = JSON.parse body
      if json.responseStatus != 200
        console.log "Error:\n\turl: #{url}\n\tquery: #{place.name}\n\tinfo: #{json.responseDetails}"
      else
        callback place, json.responseData.results

saveResults = (place, results, cb) ->
  return if not results
  placeDir = "#{uploadsPath}/#{place._id}"
  FS.mkdirSync placeDir
  c = 0
  e = 0
  for r in results
    c += 1
    url = r.url
    image = place.images.push({})
    image = place.images[image - 1]
    image.url = "/uploads/#{place._id}/#{image._id}"
    match = url.match(/\.([0-9a-z]+)$/i)
    if match
      image.ext = match[1]
    else
      c -= 1
      console.log "error", url
      e += 1
      continue
    saveFile url, image, placeDir, (err) ->
      if err
        console.log "error"
      c -= 1
      if c == 0
        cb place
  if e == results.length
    cb place

filePath = (placeDir, image, version) ->
  if version
    version = "-" + version
  else
    version = ""
  "#{placeDir}/#{image._id}#{version}.#{image.ext}"

saveFile = (url, image, placeDir, cb) ->
  protocol = url.match(/^[a-z]+/)
  if (!protocol || protocol[0] != "http")
    image.error = true
    cb(true)
    return
  
  tmp = "#{__dirname}/tmp/#{image._id}"
  file = FS.createWriteStream(tmp)
  HTTP.get url, (res) ->
    if res.statusCode != 200
      file.close()
      image.error = true
      cb(true)
      return
    res.pipe file
    file.on 'finish', ->
      file.close()
      r = filePath(placeDir, image, 'small')
      IM.convert [tmp, '-gravity', 'center', '-resize', '100x100^', '-crop', '100x100+0+0', r], (err) ->
        throw err if err
        r = filePath(placeDir, image, 'middle')
        IM.convert [tmp, '-gravity', 'center', '-resize', '320x240^', '-crop', '320x240+0+0', r], (err) ->
          throw err if err
          r = filePath(placeDir, image)
          IM.convert [tmp, '-gravity', 'center', '-resize', '640x480^', '-crop', '640x480+0+0', r], (err) ->
            throw err if err
            FS.unlink tmp
            cb()


Mongoose.connect 'mongodb://localhost/travel_foot', (err) ->
  throw err if err
  
  page = Number(process.argv[2]) || 1
  console.log "page: #{page}"
  Place.find({}).sort({_id: 1}).limit(10).skip((page - 1) * 10).exec (err, places) ->
    throw err if err
    
    console.log "found: #{places.length}"
    for p in places
      console.log "\t", p._id
    
    c = 0
    timeout = 0
    for place in places
      c += 1
      ((place) ->
        setTimeout (->
          querySearch place, (p, r) ->
            saveResults p, r, (place) ->
              place.images = _.filter place.images, (i) ->
                !i.error
              place.save (err) ->
                throw err if err
                c -= 1
                if c == 0
                  Mongoose.connection.close()
                  console.log "done"
        ), timeout
      )(place)
      timeout += 2000
