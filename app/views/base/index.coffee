Chaplin = require 'chaplin'

module.exports = class BaseView extends Chaplin.View

  autoRender: true

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

    @
