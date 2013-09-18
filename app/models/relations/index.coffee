relationshipTypes =
  HasMany: require './has_many'
  HasOne: require './has_one'

module.exports =

  buildRelations: ->

    if @relations

      for relation in @relations
        relationshipTypes[relation.type]?.build.call this, relation
