_ = require 'underscore'
$ = require 'jquery'

Backbone = require 'backbone'

require 'backbone-validation'

Backbone.Validation.configure
  forceUpdate: true

_.extend Backbone.Model.prototype, Backbone.Validation.mixin

Backbone.$ = $

require 'stickit'
