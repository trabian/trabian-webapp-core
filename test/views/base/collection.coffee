Chaplin = require 'chaplin'

BaseCollectionView = require 'core/views/base/collection'

describe 'BaseCollectionView', ->

  it 'should default to useCssAnimation', ->

    class CustomCollectionView extends BaseCollectionView

    view = new CustomCollectionView
      collection: new Chaplin.Collection

    view.useCssAnimation.should.be.ok
