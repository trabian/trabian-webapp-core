_ = require 'underscore'

utils = require './utils'

module.exports = class FakeServer

  constructor: (@options) ->

    @server = sinon.fakeServer.create()

    @server.autoRespond = @options.autoRespond ? true
    @server.autoRespondAfter = @options.delay ? 500

    @options.responses? @

  buildResponse: (method, route, response) ->

    keys = []

    route = utils.pathRegexp route, keys

    wrappedResponse = if _.isFunction response

      (req, matches...) =>

        params = @_buildParams keys, matches, req

        oldRespond = req.respond

        req.respond = =>

          if arguments.length is 1
            oldRespond.apply req, @_buildDefaultResponse arguments[0]
          else
            oldRespond.apply req, arguments

        response req, params

    else

      @_buildDefaultResponse response

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
      utils.parseQueryString query
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
