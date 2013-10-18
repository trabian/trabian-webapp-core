Chaplin = require 'chaplin'

LoadingView = require 'core/views/loading'

module.exports = class BaseApplication extends Chaplin.Application

  initialize: ->

    @initLoadingView()

    super

  initLoadingView: ->

    @subscribeEvent 'dispatcher:dispatch', (controller) =>

      if promise = controller.promise

        return if promise.state() is 'resolved'

        @showLoadingView controller

  showLoadingView: (controller) ->

    loadingView = new LoadingView
      loadingMessage: controller.loadingMessage
      region: controller.region or 'content'

    controller.promise.done ->
      loadingView.dispose()

    loadingView
