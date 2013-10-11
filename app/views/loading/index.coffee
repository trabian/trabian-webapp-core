BaseView = require 'core/views/base'

module.exports = class LoadingView extends BaseView

  className: 'loading-view'

  initialize: (options) ->

    _(options).defaults
      loadingMessage: 'Loading...'

    super

  render: ->

    @$el.html @options.loadingMessage

    @

