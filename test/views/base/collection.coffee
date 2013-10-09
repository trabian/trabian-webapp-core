Chaplin = require 'chaplin'

BaseCollectionView = require 'core/views/base/collection'

describe 'BaseCollectionView', ->

  it 'should default to useCssAnimation', ->

    class CustomCollectionView extends BaseCollectionView

    view = new CustomCollectionView
      collection: new Chaplin.Collection

    view.useCssAnimation.should.be.ok

  describe 'Presenter', ->

    it 'should pass the presenter as a first-class attribute', ->

      { Presenter } = require 'core/presenters/base'

      presenter = new Presenter

      view = new BaseCollectionView
        collection: new Chaplin.Collection
        presenter: presenter

      expect(view.presenter).to.be.ok

      view.presenter.should.equal presenter

    it 'should add stickit bindings if presenter and presenterBindings are available', ->

      { Presenter } = require 'core/presenters/base'

      presenter = new Presenter
        expanded: false

      class SampleView extends BaseCollectionView

        presenterBindings:
          ':el':
            observe: 'expanded'
            update: ($el, val) -> $el.toggleClass 'expanded', val

      view = new SampleView
        collection: new Chaplin.Collection
        presenter: presenter

      view.$el.should.not.have.class 'expanded'

      presenter.set
        expanded: true

      view.$el.should.have.class 'expanded'

