# Bootstrap Input component

FormGroup = require './form-group'

module.exports = React.createClass

  getDefaultProps: ->
    type: 'text'
    id: _.uniqueId 'input'

  render: ->

    FormGroup
      validationError: @props.validationError
    , [

      if @props.label

        text = @props.label

        labelProps =
          className: 'control-label'
          htmlFor: @props.id if @props.id
          key: 0

        if _.isObject @props.label

          text = @props.label.text

          delete @props.label.text

          _(labelProps).extend @props.label

        React.DOM.label labelProps, text

      React.DOM.input
        type: @props.type
        className: [
          'form-control',
          @props.inputClass
        ].join ' '
        autoFocus: @props.autoFocus
        disabled: @props.disabled
        id: @props.id
        key: 1
        ref: 'input'
        placeholder: @props.placeholder
        valueLink: @props.valueLink
        value: @props.value
        defaultValue: @props.defaultValue
        onChange: @props.onChange

      @props.children

    ]
