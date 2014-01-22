module.exports =

  init: ->

    window._ = require 'underscore'
    window.$ = require 'jquery'

    window.Backbone = require 'backbone'

    Backbone.$ = $

    window.moment = require 'moment'

    require('core/components/react').init()
