module.exports = React.createClass

  render: ->

    React.DOM.li
      role: 'presentation'
      key: @props.key
      className: 'active' if @props.active
      onClick: @props.onClick
    ,

      React.DOM.a
        role: 'menuitem'
        tabIndex: -1
        href: @props.href
      , @props.children
