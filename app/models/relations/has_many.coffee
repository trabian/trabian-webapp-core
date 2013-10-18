build = (relation) ->

  @onAndTrigger "change:#{relation.key}", ->
    updateCollection.call this, relation

updateCollection = (relation) ->

  { key, collectionType } = relation

  existingCollection = @previous key

  value = @get key

  if value and value instanceof collectionType

    addReverseRelation.call this, value, relation

  else

    if existingCollection and existingCollection instanceof collectionType

      # Update the existing collection
      existingCollection.reset value

      # The @set call that triggered this change has likely attempted to
      # replace the Collection with an array, so we need to undo that here.
      @set key, existingCollection, silent: true

    else

      collection = new collectionType value

      addReverseRelation.call this, collection, relation

      overrideFetch.call this, collection, key

      buildCollectionUrl.call this, collection, key

      @set key, collection, silent: true

addReverseRelation = (collection, relation) ->

  if reverse = relation.reverseRelation
    collection[reverse.key] = this

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

    if options.force or
        @isSynced() or
        not (objects = model.loadRelatedObjects key)

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

