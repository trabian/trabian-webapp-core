React = require 'react'

describe 'React.createBackboneClass', ->

  it 'should add the Backbone mixin', ->

    Component = React.createBackboneClass

      render: ->
        React.DOM.div { className: 'sample' }

    { $el, component } = renderIntoDocument Component()

    component._subscribe.should.exist
    component._unsubscribe.should.exist
    component.bindTo.should.exist

    component.el().should.exist

    $(component.el()).should.have.class 'sample'

  it 'should add the deferred mixin', ->

    Component = React.createBackboneClass

      render: ->
        React.DOM.div { className: 'sample' }

    { $el, component } = renderIntoDocument Component()

    component.updateOn.should.exist
