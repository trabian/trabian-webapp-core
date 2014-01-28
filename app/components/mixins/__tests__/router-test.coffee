RouterMixin = require 'core/components/mixins/router'

SampleClass = React.createClass

  mixins: [
    RouterMixin
  ]

  render: ->
    React.DOM.div {}

describe 'Router Mixin', ->

  it 'should be able to change properties on the component', ->

    { component } = renderIntoDocument SampleClass

      routeBase: '/app'

      addRoutes: (page) ->

        page '/test', (ctx) ->

          ctx.component.setState
            someState: 'someValue'

        page '*', (ctx, next) ->
          # Ignore

    component.navigateTo '/app/test'

    component.state.someState.should.equal 'someValue'

  it 'should support nested params', ->

    { component } = renderIntoDocument SampleClass

      addRoutes: (page) ->

        page '*', (ctx, next) ->

          ctx.component.setState
            user: 'user'

          next()

        page '/accounts/:groupId/*', (ctx, next) ->

          if ctx.params.groupId

            ctx.component.setState
              accountGroupId: ctx.params.groupId
              accountId: null

          next()

        page '/accounts/:groupId', (ctx, next) ->

          ctx.component.setState
            topLevel: true

        page "/accounts/:groupId/subaccounts/:accountId", (ctx) ->

          if ctx.params.accountId

            ctx.component.setState
              accountId: ctx.params.accountId

        page '*', (ctx, next) ->
          # Ignore

    component.navigateTo '/accounts/5/subaccounts/20'

    component.state.user.should.equal 'user'
    component.state.accountGroupId.should.equal '5'
    component.state.accountId.should.equal '20'
    expect(component.state.topLevel).to.not.be.ok
