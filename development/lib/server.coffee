_ = require 'underscore'

utils = require './utils'

module.exports = class FakeServer

  constructor: (@options) ->

    @options.delay ?= 0

    @server = sinon.fakeServer.create()

    @server.autoRespond = @options.autoRespond ? true

    @options.responses? @

  buildResponse: (method, route, response) ->

    keys = []

    useRegExpFormat = _.isRegExp route

    route = utils.pathRegexp route, keys

    # Wrap the function-based version of fakeServer's respondWith
    wrappedResponse = (req, matches...) =>

      originalRespond = req.respond

      req.respond = (responseArgs...) =>

        if responseArgs.length is 1
          responseArgs = @_buildDefaultResponse arguments[0]

        delay = _.result @options, 'delay'

        if delay

          setTimeout ->
            originalRespond.apply req, responseArgs
          , delay

        else
          originalRespond.apply req, responseArgs

      if _.isFunction response

        if useRegExpFormat

          response req, matches...

        else

          params = @_buildParams keys, matches, req
          response req, params

      else

        req.respond response

    @server.respondWith method, route, wrappedResponse

  get: (url, response) ->
    @buildResponse 'GET', url, response

  post: (url, response) ->
    @buildResponse 'POST', url, response

  restore: ->
    @server.restore()

  _buildDefaultResponse: (response) ->

    if _.isObject response
      [200, { 'Content-Type': 'application/json' }, JSON.stringify(response)]

  _buildParams: (keys, matches, req) ->

    [path, query] = req.url.split '?'

    params = if query
      Chaplin.utils.queryParams.parse query
    else
      {}

    for matchElement, index in matches

      key = keys[index]

      val = if _.isString matchElement
        decodeURIComponent matchElement
      else
        matchElement

      if key.name
        params[key.name] = val
      else
        (params.extra or= []).push val

    params
