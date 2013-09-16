Chaplin = require 'chaplin'

BaseView = require 'core/views/base'

describe 'The BaseView', ->

  describe 'autoRender', ->

    it 'should autoRender the view', ->

      class TestView extends BaseView

        render: ->
          @$el.html 'Test'
          @

      testView = new TestView

      testView.$el.should.contain 'Test'

    it 'should not cause double-rendering when used as an itemView in a CollectionView', ->

      render = sinon.spy()

      class TestView extends BaseView

        render: render

      class SomeCollectionView extends Chaplin.CollectionView

        itemView: TestView

      collection = new Chaplin.Collection [
        name: 'Item 1'
      ,
        name: 'Item 2'
      ,
        name: 'Item 3'
      ]

      collectionView = new SomeCollectionView
        collection: collection

      render.callCount.should.equal 3

  describe 'getTemplateFunction', ->

    it 'should use the "template" property as the function', ->

      class TestView extends BaseView

        template: ->
          -> "Hi."

      testView = new TestView

      testView.getTemplateFunction().should.equal testView.template
      testView.$el.should.contain 'Hi.'

    it 'should throw an error if no template property is provided', ->

      class TestView extends BaseView

      buildView = ->
        new TestView

      buildView.should.throw Error

    it 'should NOT throw an error if no template property is provided but render is overridden', ->

      class TestView extends BaseView

        render: ->

          @$el.html '<h1>Testing</h1>'

          @

      buildView = ->

        new TestView

      buildView.should.not.throw Error

  describe 'getTemplateData', ->

    beforeEach ->

      class TestView extends BaseView

        template: (data) ->
          "<h1>#{data.options.title}</h1>"

      @testView = new TestView
        title: 'Some Title'

    it 'should expose the "options" property', ->

      data = @testView.getTemplateData()

      data.should.have.property 'options'
      data.options.title.should.equal 'Some Title'

    it 'should provide the "options" property to the template', ->

      @testView.$('h1').should.contain 'Some Title'

    it 'should add the options property to the default Chaplin getTemplateData', ->

      class TestView extends BaseView

        template: -> # Empty is fine for this test

      model = new Chaplin.Model
        name: 'Some Name'

      otherTestView = new TestView
        model: model
        title: 'Some Other Title'

      data = otherTestView.getTemplateData()

      data.name.should.equal 'Some Name'
      data.options.title.should.equal 'Some Other Title'
