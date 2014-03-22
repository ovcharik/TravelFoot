ApplicationController = require './application'

class SightsController extends ApplicationController
  
  @beforeFilter 'selectSight', {only: ['show', 'edit', 'update']}
  
  index: ->
    @title = "Places"
    @page  = @params['page'] || 1
    @per   = @params['per']  || 10
    
    @allKinds = Place.getKinds()
    
    @pagination = {
      page: @page,
      per:  @per,
      path: "/sights/page"
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
  
  new: ->
    console.log 'new', @params['id']
    return true
  
  edit: ->
    console.log 'edit', @params['id']
    return true
  
  show: ->
    return true
  
  create: ->
    console.log 'create', @params
    sight = new Place(@params['sights'])
    
    @render "sights/show"
    return true
  
  update: ->
    console.log 'update', @params['id'], @params['sight']
    
    @render "sights/show"
    return true
  
  # filters
  selectSight: ->
    id = @params['id']
    if id
      Place.findOne({_id: id}).populate(['owner', 'tags']).exec (err, sight) =>
        @sight = sight
        @next()
      return false
    else
      return true

module.exports = SightsController
