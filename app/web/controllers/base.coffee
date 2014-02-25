class BaseController
  # class methods
  @beforeFilter: (name, options) ->
    _addFilter.apply @, ['before', name, options]
  
  @afterFilter: (name, options) ->
    _addFilter.apply @, ['after', name, options]
  
  @layout: (path) ->
    @_layout = path
  
  
  # public
  constructor: (@action, @request, @response) ->
    @controller = _getControllerName.apply(@)
    @layout     = @constructor._layout || "/layouts/application"
    
    @response.locals = @
    
    @initialize()
    @respond()
  
  initialize: ->
  
  respond: ->
    filters = _getFilters.apply(@)
    before  = filters.before
    after   = filters.after
    
    _applyFilters.apply(@, [before])
    @[@action].apply(@)
    @render() if not @finished()
    _applyFilters.apply(@, [after])
    @
  
  render: (value, data) ->
    if (typeof(value) == "object")
      data  = value
      value = false
    if not value
      value = "#{@controller}/#{@action}"
    @response.render value, data
    @
  
  finished: ->
    @response.finished
  
  # private
  _addFilter = (filters, name, options) ->
    options ||= {}
    if (options.only and opitions.except)
      throw "You can't define only and except for controller filter"
    
    if not @_filters
      _initFilters.apply(@)
    
    @_filters[filters].push {
      method: name,
      only:   options.only,
      except: options.except
    }
  
  _initFilters = ->
    @_filters = {
      before: []
      after:  []
    }
  
  _getFilters = ->
    @constructor._filters
  
  _applyFilters = (filters) ->
    for value in filters
      exec = not (value.except or value.only)
      exec ||= value.except and not _.contains(value.except, @action)
      exec ||= value.only   and     _.contains(value.only, @action)
      @[value.method].apply(@) if exec
    @
  
  _getControllerName = ->
    @constructor.name.replace(/Controller/, '').toLowerCase()
  
module.exports = BaseController
