DeferredMixin = require 'core/components/mixins/deferred'

describe 'Deferred mixin', ->

  it 'should add an "updateOn" method to run update when a deferred is complete', ->

    SampleComponent = React.createClass

      mixins: [DeferredMixin]

      render: ->

        React.DOM.div {}, 'TEST'

    { component } = renderIntoDocument SampleComponent()

    component.updateOn.should.be.ok

  it 'should update the component when the specified promise is complete', (done) ->

    renderCount = 0

    somePromise = $.Deferred (d) ->

      _.defer ->
        d.resolve()
        renderCount.should.equal 2
        done()

    SampleComponent = React.createClass

      mixins: [DeferredMixin]

      componentWillMount: ->
        @updateOn somePromise

      render: ->

        renderCount++

        React.DOM.div {}, 'TEST'

    { component } = renderIntoDocument SampleComponent()

  it 'should only render once if the promise was already fulfilled prior to rendering', ->

    renderCount = 0

    somePromise = $.Deferred (d) ->
      d.resolve()

    SampleComponent = React.createClass

      mixins: [DeferredMixin]

      componentWillMount: ->
        @updateOn somePromise

      render: ->

        renderCount++

        React.DOM.div {}, 'TEST'

    { component } = renderIntoDocument SampleComponent()

    renderCount.should.equal 1
