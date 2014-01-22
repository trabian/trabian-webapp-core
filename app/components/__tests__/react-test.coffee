describe.only 'React.createBackboneClass', ->

  it 'should add the Backbone mixin', ->

    Component = React.createBackboneClass

      render: ->
        React.DOM.div { className: 'sample' }

    { $el, component } = renderIntoDocument Component()

    component._subscribe.should.be.ok
    component._unsubscribe.should.be.ok
    component.bindTo.should.be.ok

    component.el().should.be.ok

    $(component.el()).should.have.class 'sample'
