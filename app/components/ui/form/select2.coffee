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

    if @props.defaultValue
      $rootNode.select2 'val', @props.defaultValue

    $rootNode.on 'change', @_handleChange

  componentDidUpdate: (prevProps, prevState) ->

    $(@getDOMNode()).select2 'val', @props.valueLink?.value || @props.defaultValue

  componentWillUnmount: ->
    $(@getDOMNode()).select2 'destroy'

  _handleChange: (e) ->
    @props.valueLink?.requestChange e.target.value
    @props.onChange? e

  render: ->

    @transferPropsTo React.DOM.select {},

      [

        if @props.placeholder
          React.DOM.option { key: 'empty '}

        @props.children

      ]
