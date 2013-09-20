build = (relation) ->

  { key, relatedModel } = relation

  @onAndTrigger "change:#{key}", ->

    if value = @get key

      unless value instanceof relatedModel
        @set key, new relatedModel(value), silent: true

  @onAndTrigger 'change:links', ->

    if link = @get('links')?[key]

      # `findLink` is dependent on dynamic data, so it needs to be a method.
      # `No need to fallback to the original `url` method since we wouldn't
      # `reach this point unless we'd already established that a link exists.
      url = => @findLink key

      if model = @get key

        # If the model exists, replace the url with the new version.
        model.url = url

      else

        # ... otherwise, create a new related model.
        @set key, new relatedModel null, { url }

module.exports = { build }
