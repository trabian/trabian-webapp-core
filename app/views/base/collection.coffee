Chaplin = require 'chaplin'

module.exports = class BaseCollectionView extends Chaplin.CollectionView

  # Animation shouldn't be done via JS - it's too slow.
  useCssAnimation: true

  getTemplateFunction: -> @template
