define ['collections/custom_fetch'], (CustomFetchCollection) ->
  class CustomFetchCollection extends Backbone.Collection
    
    fetch: (options) ->
      options = options && _.clone(options) || {}
      options.parse = true if not options.parse?
      success = options.success
      options.success = (resp) =>
        method = options.reset && 'reset' || 'set'
        models = options.modelsPath && resp[options.modelsPath] || resp
        @[method](models, options)
        success(@, resp, options) if success
        @trigger('sync', @, resp, options)
        return
      #wrapError(@, options)
      @sync('read', @, options)
