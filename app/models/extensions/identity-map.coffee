IdentityCache = require './identity_cache'

module.exports =

  _prepareModel: (attrs, options = {}) ->

    if attrs instanceof Backbone.Model
      attrs.collection ?= this
      return attrs

    options.collection = this

    idAttribute = @model?::idAttribute

    id = @model::parse(attrs)[idAttribute]

    cache = IdentityCache.getOrCreate @model

    if id and cached = cache[id]
      return cached
    else

      model = new @model attrs, options

      unless model._validate attrs, options
        @trigger 'invalid', this, attrs, options
        return false

      cache[id] = model if id

      model
