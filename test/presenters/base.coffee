{ Presenter, PresenterCollection } = require 'core/presenters/base'

describe 'Presenter', ->

  beforeEach ->
    @presenter = new Presenter


  it 'should be a Backbone.Model', ->
    @presenter.should.be.an.instanceof Backbone.Model

  describe 'event extensions', ->

    it 'should support onAndTrigger', (done) ->

      @presenter.onAndTrigger 'someEvent', ->
        done()

    it 'should support listenToAndTrigger', (done) ->

      otherPresenter = new Presenter
      presenter = @presenter

      @presenter.listenToAndTrigger otherPresenter, 'someEvent', ->
        this.should.equal presenter
        done()

describe 'PresenterCollection', ->

  beforeEach ->
    @collection = new PresenterCollection

  it 'should be a Backbone.Collection', ->
    @collection.should.be.an.instanceof Backbone.Collection

  describe 'event extensions', ->

    it 'should support onAndTrigger', (done) ->

      @collection.onAndTrigger 'someEvent', ->
        done()

    it 'should support listenToAndTrigger', (done) ->

      collection = @collection

      presenter = new Presenter

      @collection.listenToAndTrigger presenter, 'someEvent', ->
        this.should.equal collection
        done()
