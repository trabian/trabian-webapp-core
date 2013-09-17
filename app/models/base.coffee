Chaplin = require 'chaplin'

class BaseModel extends Chaplin.Model

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

  resourceName: ->
    _.result @model.prototype, 'resourceName'

  url: ->
    _.result @model.prototype, 'urlRoot'

  parse: (resp) ->

    resourceName = _.result this, 'resourceName'

    resp?[resourceName] or resp

module.exports = { BaseModel, BaseCollection }
