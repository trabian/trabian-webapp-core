module.exports =

  init: ->

    window._ = require 'underscore'
    window.$ = window.jQuery = require 'jquery'

    window.Backbone = require 'backbone'

    Backbone.$ = $

    window.moment = require 'moment'

    require 'select2'

    require('core/components/react').init()
