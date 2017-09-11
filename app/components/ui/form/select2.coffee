# Largely taken from http://jsfiddle.net/spicyj/DEpwb/

module.exports = React.createClass

  propTypes:
    children: React.PropTypes.array
    name: React.PropTypes.string
    multiple: React.PropTypes.bool
    defaultValue: React.PropTypes.string
    onChange: React.PropTypes.func

  componentDidMount: ->

    $rootNode = $ @getDOMNode()

    $rootNode.select2
      placeholder: @props.placeholder
      allowClear: @props.allowClear
      formatResult: @props.formatResult
      formatSelection: @props.formatSelection
      escapeMarkup: @props.escapeMarkup
      dropdownCssClass: 'bootstrap'
      val: @props.valueLink?.value || @props.defaultValue

    $rootNode.on 'change', @_handleChange

    $rootNode.on 'select2-open', @_handleFocus

    $rootNode.on 'select2-close', @_handleBlur

  componentDidUpdate: (prevProps, prevState) ->
    $(@getDOMNode()).select2 'val', @props.valueLink?.value || @props.value || @props.defaultValue

  componentWillUnmount: ->
    $(@getDOMNode()).select2 'destroy'

  _handleChange: (e) ->
    @props.valueLink?.requestChange e.target.value
    @props.onChange? e

  # Moving this event handler to a method allows late binding of the
  # handler without having to deal with componentWillReceiveProps.
  _handleFocus: () ->
    @props.onFocus() if @props.onFocus?

  # For some reason, changing this immediately causes the onChange
  # callback to receive an empty value.
  _handleBlur: () ->
    setTimeout @props.onBlur, 0 if @props.onBlur?

  render: ->

    @transferPropsTo React.DOM.select {},

      [

        if @props.placeholder
          React.DOM.option { key: 'empty '}

        @props.children

      ]
