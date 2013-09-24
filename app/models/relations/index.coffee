relationshipTypes =
  HasMany: require './has_many'
  HasOne: require './has_one'

module.exports =

  buildRelations: ->

    if @relations

      for relation in @relations
        relationshipTypes[relation.type]?.build.call this, relation

  # Check for IDs within the `links` attribute of the current model. This may
  # be presented as:
  #
  #   projects: [
  #     id: 1
  #     name: 'My Project'
  #     links:
  #       categories: [1, 3]
  #   ,
  #     id: 2
  #     name: 'My Other Project'
  #     links:
  #       categories: [2, 3]
  #   ],
  #   categories: [
  #     id: 1
  #     name: 'Category 1'
  #   ,
  #     id: 2
  #     name: 'Category 2'
  #   ,
  #     id: 3
  #     name: 'Category 3'
  #   ]
  #
  loadRelatedCollection: (key) ->

    resourceName = key

    if relationship = _.findWhere @relations, { key }

      if collectionType = relationship.collectionType
        resourceName = _.result collectionType.prototype, 'resourceName'

    if modelLinks = @get('links')?[key]

      # Convert ['1', '2'] to [1, 2]
      modelLinks = _.map modelLinks, (id) ->
        parseInt id

      relatedObjects = @related?[resourceName] or
        @collection?.related?[resourceName]

      if relatedObjects

        return _.filter relatedObjects, (related) ->
          related.id in modelLinks

    return
