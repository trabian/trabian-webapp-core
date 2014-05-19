cache = {}

module.exports =

  getOrCreate: (cls) ->

    cls.CACHE_KEY ?= _.uniqueId "class-cache-key-"

    cache[cls.CACHE_KEY] ?= {}

  clear: -> cache = {}
