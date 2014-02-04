module.exports =

  canFetchMore: -> !! @getLink 'next'

  fetchMore: (options = {}) ->

    _(options).defaults
      force: true
      remove: false
      url: @getLink 'next'

    @fetch options
