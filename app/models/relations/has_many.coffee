shared = require './shared'

build = (relation) ->

  { key, collectionType } = relation

  @onAndTrigger "change:#{key}", ->
    updateCollection.call this, key, collectionType

updateCollection = (key, collectionType) ->

  existingCollection = @previous key

  value = @get key

  unless value and value instanceof collectionType

    if existingCollection and existingCollection instanceof collectionType

      existingCollection.reset value

      @set key, existingCollection, silent: true

    else

      if (modelLinks = @get('links')?[key]) and not value

        modelLinks = _.map modelLinks, (id) ->
          parseInt id

        if relatedObjects = @related?[key] or @collection?.related?[key]

          value = _.filter relatedObjects, (related) ->
            related.id in modelLinks

      collection = new collectionType value

      collectionUrl = collection.url

      collection.url = =>

        if url = shared.urlForRelated.call this, key

          url

        else

          if _.isFunction collectionUrl
            collectionUrl.apply collection
          else
            collectionUrl

      @set key, collection, silent: true


module.exports = { build }

