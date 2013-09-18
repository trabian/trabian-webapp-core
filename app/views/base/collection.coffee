Chaplin = require 'chaplin'

EventExtensions = require 'core/lib/event_extensions'

module.exports = class BaseCollectionView extends Chaplin.CollectionView

  _.extend @prototype, EventExtensions

  # Animation shouldn't be done via JS - it's too slow.
  useCssAnimation: true

  getTemplateFunction: -> @template
