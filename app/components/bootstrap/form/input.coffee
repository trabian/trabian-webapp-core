# Bootstrap Input component

module.exports = React.createClass

  getDefaultProps: ->
    type: 'text'
    id: _.uniqueId 'input'

  render: ->

    groupClasses = React.addons.classSet
      'form-group': true
      'has-error': !! @props.validationError

    React.DOM.div { className: groupClasses }, [

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
        className: ['form-control', @props.inputClass].join ' '
        autoFocus: @props.autoFocus
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
