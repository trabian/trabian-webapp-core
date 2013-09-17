_ = require 'underscore'

module.exports = class FakeServer

  constructor: (@options) ->

    @server = sinon.fakeServer.create()

    @server.autoRespond = @options.autoRespond ? true
    @server.autoRespondAfter = @options.delay ? 500

    @options.responses? @

  buildResponse: (method, url, response) ->

    wrappedResponse = if _.isFunction response
      response
    else

      if _.isObject response
        [200, { 'Content-Type': 'application/json' }, JSON.stringify(response)]

    @server.respondWith method, url, wrappedResponse

  get: (url, response) ->
    @buildResponse 'GET', url, response

  post: (url, response) ->
    @buildResponse 'POST', url, response

  restore: ->
    @server.restore()
