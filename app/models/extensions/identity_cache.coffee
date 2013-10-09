cache = {}

module.exports =

  getOrCreate: (key) -> cache[key] ?= {}

  clear: -> cache = {}
