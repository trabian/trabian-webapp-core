# Router = require('director').Router

page = require 'page'

module.exports =

  componentWillMount: ->

    # Remove any previously-mounted callbacks
    page.callbacks = []

    page.base @props.routeBase

    page '*', (ctx, next) =>
      ctx.component = @
      next()

    @props.addRoutes? page

    page.start()

  componentWillUnmount: ->
    page.stop()

  navigateTo: (route) ->
    page route
