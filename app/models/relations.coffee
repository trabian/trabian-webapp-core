module.exports =

  buildRelations: ->

    if @relations

      for relation in @relations

        do (relation) =>

          { key, collectionType } = relation

          @onAndTrigger "change:#{key}", ->
            @updateCollection key, collectionType

  updateCollection: (key, collectionType) ->

    existingCollection = @previous key

    value = @get key

    unless value and value instanceof collectionType

      if existingCollection and existingCollection instanceof collectionType

        existingCollection.reset value

        @set key, existingCollection, silent: true

      else
        @set key, new collectionType(value), silent: true


