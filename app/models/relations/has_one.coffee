shared = require './shared'

build = (relation) ->

  { key, relatedModel } = relation

  @onAndTrigger "change:#{key}", ->

    if value = @get key

      unless value instanceof relatedModel
        @set key, new relatedModel(value), silent: true

  @onAndTrigger 'change:links', ->

    if links = @get 'links'

      if link = links[key]

        url = =>

          if url = shared.urlForRelated.call this, key
            url
          else
            link

        if model = @get key

          model.url = url

        else

          model = new relatedModel

          model.url = url

          @set key, model

module.exports = { build }
