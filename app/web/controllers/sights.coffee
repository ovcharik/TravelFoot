ApplicationController = require './application'

class SightsController extends ApplicationController
  
  index: ->
    @title = "Places"
    @page  = @params['page'] || 1
    @per   = @params['per']  || 10
    
    @allKinds = Place.getKinds()
    
    @pagination = {
      page: @page,
      per:  @per,
      path: "/sights"
    }
    
    @kinds = @params.kinds || Place.getKinds()
    @kindsSelected = !@params.kinds
    
    findOpts = {
      kind : { $in: @kinds }
    }
    
    Place.find(findOpts).count (err, count) =>
      @pagination.total = count
      Place.find(findOpts).sort({_id: 1}).limit(@per).skip((@page - 1) * @per).populate('tags').exec (err, places) =>
        @places = places
        @next()
    return false

module.exports = SightsController
