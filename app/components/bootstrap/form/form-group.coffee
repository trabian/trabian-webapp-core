module.exports = React.createClass

  getDefaultProps: ->
    showErrorMessage: true

  render: ->

    classes = React.addons.classSet
      'form-group': true
      'has-error': !! @props.validationError

    @transferPropsTo React.DOM.div
      className: classes
    , [

      @props.children

      if @props.showErrorMessage and @props.validationError

        React.DOM.span
          className: 'help-block text-error'
        , @props.validationError

    ]


