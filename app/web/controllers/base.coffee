class BaseController extends Module
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
    
    @params = _.extend {}, @request.query, @request.body, @request.params
    
    @initialize()
    @respond()
  
  initialize: ->
  
  respond: ->
    filters = _getFilters.apply(@)
    before  = filters.before
    after   = filters.after
    
    @stack = []
    
    _stackFilters.apply(@, [before, @stack])
    @stack.push @[@action].bind(@)
    @stack.push @defaultRender.bind(@)
    _stackFilters.apply(@, [after, @stack])
    
    @next()
    @
  
  defaultRender: ->
    if not @finished()
      @render()
    return true
  
  render: (value, data) ->
    if (typeof(value) == "object")
      data  = value
      value = false
    if not value
      value = "#{@controller}/#{@action}"
    
    _setLocals.apply(@)
    @response.render value, data
    @
  
  finished: ->
    @response.finished
  
  next: ->
    return if not @stack or @stack.length == 0
    f = @stack.shift()
    if f()
      @next()
  
  # private
  _addFilter = (filters, name, options) ->
    options ||= {}
    if (options.only and options.except)
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
  
  _stackFilters = (filters, stack) ->
    for value in filters
      exec = not (value.except or value.only)
      exec ||= value.except and not _.contains(value.except, @action)
      exec ||= value.only   and     _.contains(value.only, @action)
      stack.push @[value.method].bind(@) if @[value.method] and exec
    @
  
  _getControllerName = ->
    @constructor.name.replace(/Controller/, '').toLowerCase()
  
  _setLocals = ->
    for key, value of @
      if typeof(value) == "function"
        @response.locals[key] = value.bind(@)
      else
        @response.locals[key] = value
  
module.exports = BaseController
