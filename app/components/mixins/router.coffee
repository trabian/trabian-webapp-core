# Router = require('director').Router

page = require 'page'

module.exports =

  componentWillMount: ->

    # Remove any previously-mounted callbacks
    page.callbacks = []

    page.base @props.routeBase or ''

    page '*', (ctx, next) =>
      ctx.component = @
      next()

    @props.addRoutes? page

    page.start
      dispatch: true

  componentWillUnmount: ->
    page.stop()

  navigateTo: (route) ->
    page route
