EventExtensions = require 'core/lib/event_extensions'
RelationExtensions = require './relations'
LinkExtensions = require './links'
CollectionLinkExtensions = require './links/collection'
IdentityMapExtensions = require './extensions/identity-map'
IdentityCache = require 'core/models/extensions/identity_cache'
AllowOnlyOneExtensions = require './extensions/allow-only-one'
PaginationExtensions = require './extensions/pagination'
SyncMachine = require './extensions/sync-machine'
{ classMixin } = require './lib/mixin'

Backbone = require 'backbone'

require 'backbone-validation'

Backbone.Validation.configure
  forceUpdate: true

# Matches .01 and 123., unlike the defaults.
# See https://github.com/thedersen/backbone.validation/pull/230/files
_(Backbone.Validation.patterns).extend
  number: /^-?(?:\d+|\d{1,3}(?:,\d{3})+)?(?:\.\d*)?$/

cachePromise = (originalFetch) ->

  currentPromise = null

  return (options) ->

    return currentPromise if currentPromise and not options?.force

    @beginSync()

    currentPromise = originalFetch.apply(this, arguments).done =>
      @finishSync()
      @trigger 'reset'

_.extend Backbone.Model.prototype, Backbone.Validation.mixin

class BaseModel extends Backbone.Model

  @mixin = classMixin

  @mixin EventExtensions,
    RelationExtensions,
    LinkExtensions,
    SyncMachine

  @findOrCreate: (attrs, options={}) ->

    id = @::parse(attrs)[@::cacheIdAttribute ? @::idAttribute]

    cache = IdentityCache.getOrCreate @

    if id and not @::skipCache and cached = cache[id]
      return cached

    else

      model = new @ attrs, _(options).extend parse: true

      unless model._validate attrs, options
        @trigger 'invalid', @, attrs, options
        return false

      cache[id] = model if id and not @::skipCache

      model

  initialize: (attributes, options) ->

    if url = options?.url
      @url = url

    @fetch = cachePromise @fetch

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

class BaseCollection extends Backbone.Collection

  @mixin = classMixin

  @mixin EventExtensions,
    IdentityMapExtensions,
    AllowOnlyOneExtensions,
    CollectionLinkExtensions,
    PaginationExtensions,
    SyncMachine

  initialize: (attributes, options) ->

    if url = options?.url
      @url = url
      delete options.url

    @fetch = cachePromise @fetch

    super

    # _(this).extend $.Deferred()

    # Resolve the collection the first time it's synced (via finishSync())
    # @synced @resolve

  resourceName: ->
    _.result @model.prototype, 'resourceName'

  url: ->
    _.result @model.prototype, 'urlRoot'

  build: (attrs, opts={}) ->

    model = new @model attrs, collection: @

    model.on 'sync', _.once =>
      @add model, opts

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

  validateAll: ->
    @every (model) -> model.isValid true

  _getResourceArray: (key) ->
    @related?[key]

module.exports = { BaseModel, BaseCollection }
