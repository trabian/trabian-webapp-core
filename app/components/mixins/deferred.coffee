module.exports =

  updateOn: (promise) ->

    promise.always =>
      @forceUpdate() if @isMounted()
