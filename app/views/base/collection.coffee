Chaplin = require 'chaplin'

EventExtensions = require 'core/lib/event_extensions'

{ Presenter } = require 'core/presenters/base'

module.exports = class BaseCollectionView extends Chaplin.CollectionView

  _.extend @prototype, EventExtensions

  # Animation shouldn't be done via JS - it's too slow.
  useCssAnimation: true

  optionNames: Chaplin.CollectionView::optionNames.concat [
    'hideIfEmpty'
    'presenter'
  ]

  getTemplateFunction: -> @template

  render: ->

    super

    @initHideIfEmpty()

    if @presenterBindings and @presenter
      @stickit @presenter, @presenterBindings

    @

   #  We use a Presenter with an `empty` attribute. This way we only toggle
   #  the visibility when the value of `empty` changes. A potentially more
   #  straightforward approach would be to use something like:

   #    `@$el.toggle ! @collection.isEmpty()`

   #  However we introduced the presenter under the admittedly intution-
   #  driven assumption that the jQuery code for determining whether to
   #  toggle the element (which requires determing the current visibility) is
   #  heavier than the Backbone.Model approach of checking the existing value
   #  of a hash attribute.
  initHideIfEmpty: ->

    return unless @hideIfEmpty

    collectionPresenter = new Presenter

    @listenToAndTrigger @collection, 'add remove reset', ->

      collectionPresenter.set
        empty: @collection.isEmpty()

    @stickit collectionPresenter,
      ':el':
        observe: 'empty'
        visible: (val) -> ! val
