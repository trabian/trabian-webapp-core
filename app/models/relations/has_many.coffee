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

      collection = new collectionType value

      overrideFetch.call this, collection, key

      buildCollectionUrl.call this, collection, key

      @set key, collection, silent: true

# Override the default collection.url() method to look for the link at `key`.
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

# Override the default collection.fetch() method to first search for related
# objects returned as part of a previous fetch from the parent model.
overrideFetch = (collection, key) ->

  model = this

  _fetch = collection.fetch

  collection.fetch = (options = {}) ->

    _(options).defaults
      force: false

    if options.force or not (objects = model.loadRelatedObjects key)

      _fetch.apply this, arguments

    else

      # `fetch` should return a deferred, even if it is immediately resolved
      # (as it is in this case.)
      $.Deferred (d) =>

        @beginSync()

        @set objects

        @finishSync()

        d.resolve()

module.exports = { build }

