IdentityCache = require './identity_cache'

module.exports =

  _prepareModel: (attrs, options = {}) ->

    if attrs instanceof Backbone.Model
      attrs.collection ?= this
      return attrs

    options.collection = this

    @model?.findOrCreate attrs, options
