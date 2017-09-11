# Bootstrap Input component

FormGroup = require './form-group'

module.exports = React.createClass

  getDefaultProps: ->
    type: 'text'
    id: _.uniqueId 'input'

  render: ->

    input = React.DOM.input
      type: @props.type
      className: [
        'form-control',
        @props.inputClass
        'input'
      ].join ' '
      disabled: @props.disabled
      id: @props.id
      key: 1
      ref: 'input'
      placeholder: @props.placeholder
      valueLink: @props.valueLink
      value: @props.value
      defaultValue: @props.defaultValue
      onChange: @props.onChange
      onFocus: @props.onFocus
      onBlur: @props.onBlur
      autoComplete: @props.autoComplete
      autoCorrect: @props.autoCorrect
      autoCapitalize: @props.autoCapitalize
      autoFocus: @props.autoFocus
      spellCheck: @props.spellCheck

    inputsAndAddons = if @props.addonBefore or @props.addonAfter
      React.DOM.div
        className: 'input-group'
      , [
        if @props.addonBefore
          React.DOM.div
            className: 'input-group-addon'
          , @props.addonBefore
        input,
        if @props.addonAfter
          React.DOM.div
            className: 'input-group-addon'
          , @props.addonAfter
      ]
    else
      input

    FormGroup
      className: @props.className
      validationError: @props.validationError
    , [

      if @props.label

        text = @props.label

        labelProps =
          className: [
            'control-label',
            @props.labelClass
          ].join ' '
          htmlFor: @props.id if @props.id
          key: 0

        if _.isObject @props.label

          text = @props.label.text

          delete @props.label.text

          _(labelProps).extend @props.label

        React.DOM.label labelProps, text

      if @props.horizontal
        React.DOM.div
          className: @props.inputContainerClass
          inputsAndAddons
      else
          inputsAndAddons

      @props.children

    ]
