# Bootstrap Input compontent

module.exports = React.createClass

  getDefaultProps: ->
    type: 'text'
    id: _.uniqueId 'input'

  componentDidMount: ->

    if @props.focus
      @refs.input.getDOMNode().focus()

  render: ->

    React.DOM.div { className: 'form-group' }, [

      if @props.label

        text = @props.label

        labelProps =
          htmlFor: @props.id if @props.id
          key: 0

        if _.isObject @props.label

          text = @props.label.text

          delete @props.label.text

          _(labelProps).extend @props.label

        React.DOM.label labelProps, text

      React.DOM.input
        type: @props.type
        className: 'form-control'
        id: @props.id
        key: 1
        ref: 'input'
        placeholder: @props.placeholder
        valueLink: @props.valueLink
        value: @props.value
        onChange: @props.onChange

      @props.children

    ]
