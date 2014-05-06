require('../app').init()

React = require 'react'

global.renderIntoDocument = (instance, callback) ->

  div = document.createElement 'div'

  div.id = 'component-wrapper'

  document.documentElement.appendChild div

  component = React.renderComponent instance, div, callback

  el = div.children[0]

  component: component
  el: el
  $el: $(el)
  parent: div

afterEach ->

  if div = document.getElementById 'component-wrapper'
    React.unmountComponentAtNode div
    document.documentElement.removeChild div
