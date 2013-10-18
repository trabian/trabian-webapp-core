Chaplin = require 'chaplin'

EventExtensions = require 'core/lib/event_extensions'
PromiseExtensions = require './extensions/promise'

module.exports = class BaseView extends Chaplin.View

  _.extend @prototype, EventExtensions, PromiseExtensions

  autoRender: true

  optionNames: Chaplin.View::optionNames.concat ['presenter']

  initialize: ->

    @initPromise()

    super

  getTemplateFunction: ->
    throw new Error '@template is required' unless @template?
    @template

  # Passing in the @options to getTemplateData can remove a lot
  # getTemplateDate overrides.
  getTemplateData: ->
    _(super).defaults { @options }

  render: ->

    super

    if @bindings and @model
      @stickit()

    if @presenterBindings and @presenter
      @stickit @presenter, @presenterBindings

    @

  delegateListener: (eventName, target, callback) ->

    if target is 'presenter'
      @listenTo @presenter, eventName, callback if @presenter
    else
      super

    return
