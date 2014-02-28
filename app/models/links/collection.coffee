module.exports =

  getLink: (key) ->

    @links?[key] or if defaultLink = @defaultLinks?[key]

      if _.isFunction defaultLink
        defaultLink.call this
      else
        defaultLink
