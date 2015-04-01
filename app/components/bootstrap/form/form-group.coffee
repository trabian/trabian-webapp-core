module.exports = React.createClass

  getDefaultProps: ->
    showErrorMessage: true
    styleClass: 'form-group'

  render: ->

    errorClass = 'has-error' if @props.validationError

    classes = React.addons.classSet @props.styleClass, errorClass

    @transferPropsTo React.DOM.div
      className: classes
    , [

      @props.children

      if @props.showErrorMessage and @props.validationError

        React.DOM.span
          className: 'help-block text-error'
        , @props.validationError

    ]
