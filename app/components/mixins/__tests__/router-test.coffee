RouterMixin = require 'core/components/mixins/router'

SampleClass = React.createClass

  mixins: [
    RouterMixin
  ]

  render: ->
    React.DOM.div {}

describe 'Router Mixin', ->

  it 'should load the provided routes and attach the component to the route context as "this.component"', (done) ->

    attachedComponent = null
    testId = null

    { component } = renderIntoDocument SampleClass

      defaultRoute: '/test/3'

      routes:

        '/test/:id': (id) ->
          attachedComponent = @component
          testId = parseInt id

    router = component.props.router

    router.should.exist

    _.defer ->
      testId.should.equal 3
      attachedComponent.should.equal component
      done()

  it 'should be able to change properties on the component', ->

    { component } = renderIntoDocument SampleClass

      defaultRoute: '/test'

      routes:
        '/test': ->
          @component.setState
            someState: 'someValue'

    component.state.someState.should.equal 'someValue'

  it 'should support nested params', ->

    { component } = renderIntoDocument SampleClass

      defaultRoute: '/accounts/5/subaccounts/20'

      routes:

        '/': ->

          @component.setState
            user: 'user'

        '/accounts/:id':

          on: (accountId) ->

            @component.setState
              accountId: accountId
              main: ->
                'main account'

          '/subaccounts/:id':

            on: (accountId, subaccountId) ->

              @component.setState
                subaccountId: subaccountId
                main: ->
                  'subaccount'

    component.state.user.should.equal 'user'
    component.state.accountId.should.equal '5'
    component.state.subaccountId.should.equal '20'
    component.state.main().should.equal 'subaccount'
