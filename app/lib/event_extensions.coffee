module.exports =

  # A common pattern when defining events is to immediately want to call the
  # callback. For example:
  #
  # myCallback = ->
  #   alert 'do something!'
  #
  # @on 'someEvent', myCallback
  #
  # myCallback()
  #
  # This method allows us to combine those:
  #
  # @onAndTrigger 'someEvent', ->
  #   alert 'do something!'
  #
  onAndTrigger: (event, callback, context) ->
    @on event, callback, context
    callback.apply context ? this

  # This is similar to onAndTrigger but listens to events on an `other`
  # object.
  listenToAndTrigger: (other, event, callback) ->
    @listenTo other, event, callback
    callback.apply this
