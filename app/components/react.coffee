module.exports =

  init: ->

    return unless React?

    BackboneMixin = require 'core/components/mixins/backbone'
    DeferredMixin = require 'core/components/mixins/deferred'

    React.createBackboneClass = (spec) ->

      currentMixins = spec.mixins or []

      spec.mixins = currentMixins.concat [
        BackboneMixin
        DeferredMixin
      ]

      spec.getModel = ->
        @props.model

      spec.model = ->
        @getModel()

      spec.el = ->
        @isMounted() && @getDOMNode()

      React.createClass spec
