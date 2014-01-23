module.exports =

  init: ->

    return unless React?

    BackboneMixin = require 'core/components/mixins/backbone'

    React.createBackboneClass = (spec) ->

      currentMixins = spec.mixins or []

      spec.mixins = currentMixins.concat [BackboneMixin]

      spec.getModel = ->
        @props.model

      spec.model = ->
        @getModel()

      spec.el = ->
        @isMounted() && @getDOMNode()

      React.createClass spec
