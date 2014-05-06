React = require 'react'

module.exports =

  init: ->

    BackboneMixin = require './mixins/backbone'
    DeferredMixin = require './mixins/deferred'

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
