Chaplin = require 'chaplin'

EventExtensions = require 'core/lib/event_extensions'
RelationExtensions = require './relations'
LinkExtensions = require './links'
IdentityMapExtensions = require './extensions/identity_map'

class BaseModel extends Chaplin.Model

  _.extend @prototype,
    EventExtensions,
    RelationExtensions,
    LinkExtensions,
    Chaplin.SyncMachine

  initialize: ->

    super

    _(this).extend $.Deferred()

    @buildRelations()

    # Resolve the model the first time it's synced (via finishSync())
    @synced @resolve

  fetch: ->

    @beginSync()

    super.done => @finishSync()

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

  _getResourceArray: (key) ->
    @related?[key] or @collection?._getResourceArray key

  # Add the 'method' to the options so it can be passed to toJSON
  sync: (method, model, options = {}) ->

    _(options).defaults { method }

    super method, model, options

class BaseCollection extends Chaplin.Collection

  _.extend @prototype,
    EventExtensions,
    IdentityMapExtensions,
    Chaplin.SyncMachine

  initialize: ->

    super

    _(this).extend $.Deferred()

    # Resolve the collection the first time it's synced (via finishSync())
    @synced @resolve

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

  fetch: (options = {}) ->

    _(options).defaults
      force: false

    if options.force or not @isSynced()

      @beginSync()

      super.done => @finishSync()

    else

      $.Deferred (d) -> d.resolve()

  _getResourceArray: (key) ->
    @related[key]

module.exports = { BaseModel, BaseCollection }
