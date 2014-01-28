Router = require('director').Router

module.exports =

  componentWillMount: ->

    self = @

    if @props.routes

      @props.router = Router(@props.routes).configure

        html5history: true

        recurse: 'forward'

        before: ->
          @component = self

      .init @props.defaultRoute

