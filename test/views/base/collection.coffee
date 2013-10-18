Chaplin = require 'chaplin'

BaseView = require 'core/views/base'
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

  describe 'hideIfEmpty', ->

    beforeEach ->

      class ItemView extends BaseView

        render: ->

          @$el.html @id

          this

      class SampleView extends BaseCollectionView

        itemView: ItemView

      class HiddenSampleView extends BaseCollectionView

        hideIfEmpty: true

        itemView: ItemView

      @classes = { SampleView, HiddenSampleView }

    it 'should pass the "hideIfEmpty" property to the view', ->

      { SampleView } = @classes

      collection = new Chaplin.Collection

      view = new SampleView
        collection: collection
        hideIfEmpty: true

      view.options.hideIfEmpty.should.be.true

    it 'should be able to hide the view if the collection is empty', ->

      { SampleView, HiddenSampleView } = @classes

      collection = new Chaplin.Collection

      view = new SampleView
        collection: collection

      otherView = new HiddenSampleView
        collection: collection

      hiddenInOptionsView = new SampleView
        collection: collection
        hideIfEmpty: true

      view.$el.should.not.have.css 'display', 'none'

      otherView.$el.should.have.css 'display', 'none'

      hiddenInOptionsView.$el.should.have.css 'display', 'none'

    it 'should be able to hide the view if the collection is empty', ->

      { SampleView, HiddenSampleView } = @classes

      collection = new Chaplin.Collection

      otherView = new HiddenSampleView
        collection: collection

      otherView.$el.should.have.css 'display', 'none'

    it 'should be visible if the collection is populated', ->

      { SampleView, HiddenSampleView } = @classes

      collection = new Chaplin.Collection [
        id: 1
      ]

      otherView = new HiddenSampleView
        collection: collection

      otherView.$el.should.not.have.css 'display', 'none'

    it 'should be visible if the collection is populated later', ->

      { SampleView, HiddenSampleView } = @classes

      collection = new Chaplin.Collection

      otherView = new HiddenSampleView
        collection: collection

      otherView.$el.should.have.css 'display', 'none'

      collection.add [
        id: 1
      ]

      otherView.$el.should.not.have.css 'display', 'none'

    it 'should be hidden if the collection is empty later', ->

      { SampleView, HiddenSampleView } = @classes

      collection = new Chaplin.Collection [
        id: 1
      ]

      otherView = new HiddenSampleView
        collection: collection

      otherView.$el.should.not.have.css 'display', 'none'

      collection.remove 1

      otherView.$el.should.have.css 'display', 'none'

    it 'should be hidden if the collection is reset', ->

      { SampleView, HiddenSampleView } = @classes

      collection = new Chaplin.Collection [
        id: 1
      ]

      otherView = new HiddenSampleView
        collection: collection

      otherView.$el.should.not.have.css 'display', 'none'

      collection.reset()

      otherView.$el.should.have.css 'display', 'none'

      collection.reset [
        id: 1
      ]

      otherView.$el.should.not.have.css 'display', 'none'
