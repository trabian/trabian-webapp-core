module.exports =

  loadMore: (e) ->
    e.preventDefault()
    @forceUpdate()
    @updateOn @props.model.fetchMore()

  canLoadMore: ->
    @props.model.canFetchMore() and not @props.count

  renderLoadMore: ->

    if @canLoadMore()

      React.DOM.div
        className: 'panel-footer'
      , React.DOM.a
        href: '#'
        className: 'btn btn-default btn-block'
        disabled: @props.model.isSyncing()
        onClick: @loadMore
      , 'Load more...'
