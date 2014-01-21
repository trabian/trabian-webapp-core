_ = require 'underscore'
$ = require 'jquery'

Backbone = require 'backbone'

require 'backbone-validation'

Backbone.Validation.configure
  forceUpdate: true

_.extend Backbone.Model.prototype, Backbone.Validation.mixin

Backbone.$ = $

require 'stickit'

{ ReactTestUtils } = React.addons

renderIntoDocument = (instance, callback) ->

  div = document.createElement 'div'

  document.documentElement.appendChild div

  component = React.renderComponent instance, div, callback

  el = div.children[0]

  component: component
  el: el
  $el: $(el)
  parent: div

