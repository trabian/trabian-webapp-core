build = (relation) ->

  { key, relatedModel, linkKey } = relation

  linkKey ?= key

  @onAndTrigger "change:#{key}", ->

    if value = @get key

      unless value instanceof relatedModel
        @set key, (value = new relatedModel value), silent: true

      addReverseRelation.call this, value, relation

  @onAndTrigger 'change:links', ->

    if link = @getLink linkKey

      # `findLink` is dependent on dynamic data, so it needs to be a method.
      # `No need to fallback to the original `url` method since we wouldn't
      # `reach this point unless we'd already established that a link exists.
      url = => @findLink linkKey

      if model = @get key

        # If the model exists, replace the url with the new version.
        model.url = url

      else

        # ... otherwise, create a new related model.
        @set key, (model = new relatedModel null, { url })

      addReverseRelation.call this, model, relation

addReverseRelation = (model, relation) ->

  if reverse = relation.reverseRelation
    model[reverse.key] = this

module.exports = { build }
