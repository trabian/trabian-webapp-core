PropTransferClass = require '../../utils/prop-transfer'

module.exports = React.createClass

  render: ->

    @transferPropsTo React.DOM.div
      className: 'dropdown'
    , [

      if @props.renderToggle

        PropTransferClass
          className: 'dropdown-toggle'
          key: 'dropdown-toggle'
          'data-toggle': 'dropdown'
          renderComponent: @props.renderToggle

      if @props.children?.length > 1

        React.DOM.ul
          key: 'dropdown-list'
          className: 'dropdown-menu'
        , @props.children

    ]
