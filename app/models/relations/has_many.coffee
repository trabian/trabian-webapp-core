UriTemplate = require 'uritemplate'

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

        if url = urlForRelated.call this, key

          url

        else

          if _.isFunction collectionUrl
            collectionUrl.apply collection
          else
            collectionUrl

      @set key, collection, silent: true

urlForRelated = (key) ->

  modelLinks = @get('links')?[key]

  resourceName = _.result this, 'resourceName'

  linkName = [resourceName, key].join '.'

  template = @collection?.links?[linkName]

  if template

    if _.isObject template
      template = template.href

    template = UriTemplate.parse template

    expansionKeys = {}

    # Collection attributes from model. For instance:
    #
    #   expansionKeys["projects.id"] = project.id
    #   expansionKeys["projects.key"] = project.get 'key'
    #
    for attrName, value of @attributes
      expansionKeys["#{resourceName}.#{attrName}"] = value

    # Add any links provided at the model level. For instance:
    #
    #   projects: [
    #     id: 1
    #     links:
    #       todos: ['1', '2']
    #   ]
    #
    #   expansionKeys["projects.todos"] = ['1', '2']
    #
    expansionKeys["#{resourceName}.#{key}"] = modelLinks

    template.expand expansionKeys

  else

    # No top-level link template is available, so use the link provided at
    # the model level (if available).
    #
    #   projects: [
    #     id: 1
    #     links:
    #       todos: '/projects/1/todos'
    #   ]
    #
    #   urlForRelated('todos') == '/projects/1/todos'
    #
    modelLinks

module.exports = { build }

