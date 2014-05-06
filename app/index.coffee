module.exports =

  init: ->

    global._ = require 'underscore'

    global.$ = global.jQuery = require 'jquery'

    global.Backbone = require 'backbone'

    global.Backbone.$ = global.$

    global.moment = require 'moment'

    global.React = require 'react/addons'

    unless typeof window is 'undefined'
      require 'select2'

    require('./components/react').init()

module.exports.init()
