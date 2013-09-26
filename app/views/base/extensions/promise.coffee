module.exports =

  # If a `promise` is passed as an option to the view instance, display a
  # loading indicator (by default) and wait until the promise is fulfilled
  # before rendering the view.
  initPromise: ->

    promise = @options.promise

    return unless promise and promise.state() isnt 'resolved'

    # We'll render once the promise is fulfilled.
    @autoRender = false

    # We want to be able to show the loading indicator, so let's go ahead and
    # attach the element to the DOM.
    if @autoAttach
      @attach()
      @autoAttach = false

    @$el.addClass 'loading'

    $loadingIndicator = @renderLoadingIndicator.apply this

    removeLoadingIndicator = ->
      $loadingIndicator?.remove()
      $loadingIndicator = null

    # When the promise is fulfilled, remove the loading indicator and the
    # `loading` class, then render the view.
    promise.done =>
      removeLoadingIndicator()
      @$el.removeClass 'loading'
      @render()

    # Wrap the `dispose` method to remove the loading indicator if it exists.
    #
    # This may be necessary if the view is disposed before the promise is
    # resolved. While the `loadingIndicator` may be a child of the view's
    # element which would be removed during disposal anyway, there's nothing
    # preventing the loadingIndicator from being attached to another element
    # (such as the `body`).
    dispose = @dispose

    @dispose = =>
      return false if @disposed
      removeLoadingIndicator()
      dispose.apply this, arguments

  # Render the `loadingIndicator` and return it from this method to make sure
  # it's properly removed when the promise is resolved or the view is
  # disposed.
  #
  # The default behavior is to create a paragraph with class of `loading-
  # text` and append it to the view's element. The text of the paragraph will
  # be either the `loadingText` option passed to the view or 'Loading...' if
  # that option is not provided.
  renderLoadingIndicator: ->

    if loadingText = @options.loadingText ? 'Loading...'

      $("<p class='loading-text'>#{loadingText}</p>")
        .appendTo @$el
