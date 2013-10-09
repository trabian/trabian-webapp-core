IdentityCache = require './identity_cache'

module.exports =

  _prepareModel: (attrs, options = {}) ->

    if attrs instanceof Backbone.Model
      attrs.collection ?= this
      return

    options.collection = this

    idAttribute = @model?::idAttribute

    if id = attrs[idAttribute]

      cache = IdentityCache.getOrCreate @model

      if cached = cache[attrs.id]
        return cached
      else

        model = new @model attrs, options

        unless model._validate attrs, options
          @trigger 'invalid', this, attrs, options
          return false

        return cache[id] = model
