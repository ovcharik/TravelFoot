ApplicationController = require './application'

class SightsController extends ApplicationController
  
  index: ->
    @title = "Places"
    @page  = @params['page'] || 1
    @per   = @params['per']  || 10
    
    @pagination = {
      page: @page,
      per:  @per,
      path: "/sights"
    }
    
    Place.find().count (err, count) =>
      @pagination.total = count
      
      Place.find().sort({_id: 1}).limit(@per).skip((@page - 1) * 10).populate('tags').exec (err, places) =>
        @places = places
        @next()
    return false

module.exports = SightsController
