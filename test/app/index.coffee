BaseApplication = require 'core/application/base'
BaseView = require 'core/views/base'

LoadingView = require 'core/views/loading'

describe 'BaseApplication', ->

  describe 'loading view', ->

    beforeEach ->

      class MyApplication extends BaseApplication

      @application = new MyApplication

      class WrapperView extends BaseView

        regions:
          'content': '.content'

        template: -> ''

      # Register 'content' region
      new WrapperView

      sinon.spy MyApplication.prototype, 'showLoadingView'

      @classes = { MyApplication }

    afterEach ->

      { MyApplication } = @classes

      @application.dispose()

      MyApplication::showLoadingView.restore()

    it 'should show the loading view if a dispatched controller has an unresolved promise', ->

      promise = new $.Deferred()

      controller = { promise }

      @application.showLoadingView.should.not.have.been.called

      @application.publishEvent 'dispatcher:dispatch', controller

      @application.showLoadingView.should.have.been.calledOnce

    it 'should not show the loading view if the dispatched controller has an resolved promise', ->

      promise = new $.Deferred()

      promise.resolve()

      controller = { promise }

      @application.showLoadingView.should.not.have.been.called

      @application.publishEvent 'dispatcher:dispatch', controller

      @application.showLoadingView.should.not.have.been.called

    it 'should pass the controller to showLoadingView', ->

      promise = new $.Deferred()

      controller = { promise }

      @application.showLoadingView.should.not.have.been.called

      @application.publishEvent 'dispatcher:dispatch', controller

      @application.showLoadingView.should.have.been.calledWith controller

    describe 'LoadingView', ->

      beforeEach =>

      it 'should create a LoadingView', ->

        promise = new $.Deferred()

        view = @application.showLoadingView
          promise: promise
          loadingMessage: 'Testing'

        expect(view).to.be.ok

        view.should.be.an.instanceof LoadingView

        view.$el.should.contain 'Testing'

        view.disposed.should.be.false

        promise.resolve()

        view.disposed.should.be.true
