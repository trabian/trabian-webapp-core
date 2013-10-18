Chaplin = require 'chaplin'

BaseView = require 'core/views/base'

describe 'The BaseView with promises', ->

  beforeEach ->

    @promise = new $.Deferred()

    class TestView extends BaseView

      render: ->
        @$el.html 'Test'
        @

    @classes = { TestView }

    @testView = new TestView { @promise }

  it 'should not autoRender the view', ->

    @testView.$el.should.not.contain 'Test'

  it 'should render the view when the promise is fulfilled', ->

    @promise.resolve()

    @testView.$el.should.contain 'Test'

  it 'should autoRender the view if the promise is already resolved', ->

    { TestView } = @classes

    @promise.resolve()

    customTestView = new TestView { @promise }

    customTestView.$el.should.contain 'Test'

  describe 'loading state', ->

    it 'should have the "loading" class during fulfillment', ->

      @testView.$el.should.have.class 'loading'

      @promise.resolve()

      @testView.$el.should.not.have.class 'loading'

    it 'should show the loading text during fulfillment', ->

      @testView.$el.should.contain 'Loading...'

      @promise.resolve()

      @testView.$el.should.not.contain 'Loading...'

    it 'should show custom loading text if provided', ->

      { TestView } = @classes

      loadingText = 'Loading details...'

      customTestView = new TestView { @promise, loadingText }

      customTestView.$el.should.contain loadingText

      @promise.resolve()

      customTestView.$el.should.not.contain loadingText

    describe 'custom loading indicator', ->

      beforeEach ->

        class CustomLoadingTestView extends BaseView

          render: ->
            @$el.html 'Test'
            @

          renderLoadingIndicator: ->

            $('<div class="loading-alert">Loading!</div>').
              appendTo $ 'body'

        @customView = new CustomLoadingTestView { @promise }

      it 'should be removed on resolve', ->

        $loadingMessage = $('body').find '.loading-alert'

        $loadingMessage.should.exist
        $loadingMessage.should.contain 'Loading!'

        @promise.resolve()

        $loadingMessage = $('body').find '.loading-alert'

        $loadingMessage.should.not.exist

      it 'should be removed on disposal of the view', ->

        $loadingMessage = $('body').find '.loading-alert'

        $loadingMessage.should.exist

        @customView.dispose()

        $loadingMessage = $('body').find '.loading-alert'

        $loadingMessage.should.not.exist

      it 'should not cause a problem if the view is disposed after resolution', ->

        $loadingMessage = $('body').find '.loading-alert'

        $loadingMessage.should.exist

        @promise.resolve()
        @customView.dispose()

        $loadingMessage = $('body').find '.loading-alert'

        $loadingMessage.should.not.exist
