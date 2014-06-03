{ button, div, h4 } = React.DOM

module.exports = React.createClass

  componentDidMount: ->

    $(@getDOMNode()).modal
      backdrop: 'static'
      keyboard: false
      show: false

  componentWillUnmount: ->
    $(@getDOMNode()).off 'hidden', @handleHidden

  close: ->
    @props.onClose?()
    $(@getDOMNode()).modal 'hide'

  open: ->
    @props.onOpen?()
    $(@getDOMNode()).modal 'show'

  handleCancel: (e) ->
    e.preventDefault()
    @close()
    @props.onCancel?()

  render: ->

    dialogClasses = React.addons.classSet
      'modal-dialog': true
      'modal-lg': 'large' is @props.size
      'modal-sm': 'small' is @props.size

    div { className: 'modal' },
      div { className: dialogClasses },
        div { className: 'modal-content' },
          div { className: 'modal-header' },

            button
              type: 'button'
              className: 'close'
              onClick: @handleCancel
              dangerouslySetInnerHTML:
                __html: '&times;'

            h4 { className: 'modal-title' }, @props.title

          @props.children

          unless @props.noFooter
            div { className: 'modal-footer' },

              button
                className: 'btn btn-default'
                onClick: @handleCancel
              , 'Cancel'
