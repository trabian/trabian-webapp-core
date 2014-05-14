Chaplin = require 'chaplin'

EventExtensions = require 'core/lib/event_extensions'
RelationExtensions = require './relations'
LinkExtensions = require './links'
CollectionLinkExtensions = require './links/collection'
IdentityMapExtensions = require './extensions/identity-map'
IdentityCache = require 'core/models/extensions/identity_cache'
AllowOnlyOneExtensions = require './extensions/allow-only-one'
PaginationExtensions = require './extensions/pagination'
{ classMixin } = require './lib/mixin'

Backbone = require 'backbone'

require 'backbone-validation'

Backbone.Validation.configure
  forceUpdate: true

_.extend Backbone.Model.prototype, Backbone.Validation.mixin

class BaseModel extends Chaplin.Model

  @mixin = classMixin

  @mixin EventExtensions,
    RelationExtensions,
    LinkExtensions,
    Chaplin.SyncMachine

  @findOrCreate: (attrs, options={}) ->

    idAttribute = @::idAttribute

    id = @::parse(attrs)[idAttribute]

    cache = IdentityCache.getOrCreate @

    if id and cached = cache[id]
      return cached

    else

      model = new @ attrs, options

      unless model._validate attrs, options
        @trigger 'invalid', @, attrs, options
        return false

      cache[id] = model if id

      model

  initialize: (attributes, options) ->

    if url = options?.url
      @url = url

    super

    # _(this).extend $.Deferred()

    @buildRelations()

    # Resolve the model the first time it's synced (via finishSync())
    # @synced @resolve

  fetch: (options = {}) ->

    _(options).defaults
      force: false

    if options.force or not @isSynced()

      @beginSync()

      super.done => @finishSync()

    else

      $.Deferred (d) -> d.resolve()

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
    _.first(resp?[@resourceName]) or
      resp?[@resourceName] or
      resp?.data?[@resourceName] or
      resp?.data or
      resp

  _getResourceArray: (key) ->
    @related?[key] or @collection?._getResourceArray key

  # Add the 'method' to the options so it can be passed to toJSON
  sync: (method, model, options = {}) ->

    _(options).defaults
      syncMethod: method

    super method, model, options

class BaseCollection extends Chaplin.Collection

  @mixin = classMixin

  @mixin EventExtensions,
    IdentityMapExtensions,
    AllowOnlyOneExtensions,
    CollectionLinkExtensions,
    PaginationExtensions,
    Chaplin.SyncMachine

  initialize: (attributes, options) ->

    if url = options?.url
      @url = url

    super

    # _(this).extend $.Deferred()

    # Resolve the collection the first time it's synced (via finishSync())
    # @synced @resolve

  resourceName: ->
    _.result @model.prototype, 'resourceName'

  url: ->
    _.result @model.prototype, 'urlRoot'

  build: (attrs) ->

    model = new @model attrs, collection: @

    model.on 'sync', => @add model

  parse: (resp) ->

    return unless resp

    resourceName = _.result this, 'resourceName'

    if _.isObject resp

      @links = resp.links

      for key, value of resp when key isnt 'links'
        (@related or= {})[key] = value

    val = resp[resourceName] ? resp.data?[resourceName] ? resp.data ? resp

    if _.isArray val
      val
    else
      []

  fetch: (options = {}) ->

    _(options).defaults
      force: false

    if options.force or not @isSynced()

      @beginSync()

      super.done => @finishSync()

    else

      $.Deferred (d) -> d.resolve()

  validateAll: ->
    @every (model) -> model.isValid true

  _getResourceArray: (key) ->
    @related?[key]

module.exports = { BaseModel, BaseCollection }
