Chaplin = require 'chaplin'

EventExtensions = require 'core/lib/event_extensions'

class Presenter extends Chaplin.Model

  _.extend @prototype,
    EventExtensions

class PresenterCollection extends Chaplin.Collection

  model: Presenter

  _.extend @prototype,
    EventExtensions

module.exports = { Presenter, PresenterCollection }
