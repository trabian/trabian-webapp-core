Chaplin = require 'chaplin'

EventExtensions = require 'core/lib/event_extensions'
RelationExtensions = require './relations'
LinkExtensions = require './links'

class BaseModel extends Chaplin.Model

  _.extend @prototype, EventExtensions, RelationExtensions, LinkExtensions

  initialize: ->

    super

    @buildRelations()

  # For individual model requests the data will be returned as the only
  # element of an array at `resourceName`. For example, if resourceName is
  # `projects`:
  #
  # {
  #   projects: [
  #     ... project info ...
  #   ]
  # }
  #
  # When the `parse` method is called by a collection to parse the individual
  # models in the collection the `resp` parameter will contain the unwrapped
  # model data.
  parse: (resp) ->

    _.first(resp?[@resourceName]) or resp

class BaseCollection extends Chaplin.Collection

  _.extend @prototype, EventExtensions

  resourceName: ->
    _.result @model.prototype, 'resourceName'

  url: ->
    _.result @model.prototype, 'urlRoot'

  parse: (resp) ->

    return unless resp

    resourceName = _.result this, 'resourceName'

    if _.isObject resp

      if links = resp.links
        @links = links

      for key, value of resp when key isnt 'links'
        (@related or= {})[key] = value

    resp[resourceName] or resp

module.exports = { BaseModel, BaseCollection }
