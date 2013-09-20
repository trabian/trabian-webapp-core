build = (relation) ->

  { key, collectionType } = relation

  @onAndTrigger "change:#{key}", ->
    updateCollection.call this, key, collectionType

updateCollection = (key, collectionType) ->

  existingCollection = @previous key

  value = @get key

  unless value and value instanceof collectionType

    if existingCollection and existingCollection instanceof collectionType

      # Update the existing collection
      existingCollection.reset value

      # The @set call that triggered this change has likely attempted to
      # replace the Collection with an array, so we need to undo that here.
      @set key, existingCollection, silent: true

    else

      unless value
        value = @loadRelatedCollection key

      collection = new collectionType value

      buildCollectionUrl.call this, collection, key

      @set key, collection, silent: true

# Overwrite the default collection.url() method to look for the link at `key`.
# This needs to happen at the time the url is requested as the link may not
# have been available when the association was first created.
buildCollectionUrl = (collection, key) ->

  originalUrl = collection.url

  collection.url = =>

    if url = @findLink key
      url

    else

      if _.isFunction originalUrl
        originalUrl.apply collection
      else
        originalUrl

module.exports = { build }

