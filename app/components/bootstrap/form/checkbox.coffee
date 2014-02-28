# Bootstrap Checkbox component

module.exports = React.createClass

  render: ->

    groupClasses = React.addons.classSet
      'form-group': true
      'has-error': !! @props.validationError

    React.DOM.div { className: groupClasses }, [

      React.DOM.div { className: 'checkbox' }, [

        React.DOM.label {},

          React.DOM.input
            type: 'checkbox'
            id: @props.id
            className: @props.inputClass
            key: 1
            ref: 'checkbox'
            checkedLink: @props.checkedLink
            checked: @props.checked
            defaultChecked: @props.defaultChecked
            onChange: @props.onChange

          @props.label

      ]

      @props.children

    ]
