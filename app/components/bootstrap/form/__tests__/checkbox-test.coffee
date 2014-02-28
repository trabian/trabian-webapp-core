Checkbox = require 'core/components/bootstrap/form/checkbox'

describe 'Checkbox component', ->

  it 'should be a component', ->

    rendered = renderIntoDocument Checkbox()

    rendered.$el.should.be.ok

  it 'should wrap the checkbox (and label) in a form-group', ->

    rendered = renderIntoDocument Checkbox()

    rendered.$el.should.be '.form-group'

  it 'should render a label iff a label is provided', ->

    rendered = renderIntoDocument Checkbox
      label: 'Some Label'

    rendered.$el.should.contain 'Some Label'

  it 'should pass the inputClass property to the input class', ->

    rendered = renderIntoDocument Checkbox
      inputClass: 'some-checkbox-class'

    rendered.$el.find(':checkbox').should.have.class 'some-checkbox-class'

  it 'should set a value and onChange on the input if provided', ->

    changed = false

    rendered = renderIntoDocument Checkbox
      checked: false
      onChange: ->
        changed = true

    rendered.$el.find(':checkbox').is(':checked').should.be.false

    checkbox = React.addons.TestUtils.findRenderedDOMComponentWithTag(rendered.component, 'input').getDOMNode()

    checkbox.value = true

    React.addons.TestUtils.Simulate.change checkbox

    changed.should.be.true

  it 'should set a valueLink on the input if provided', ->

    changed = false

    rendered = renderIntoDocument Checkbox
      checkedLink:
        value: true
        requestChange: ->
          changed = true

    rendered.$el.find(':checkbox').is(':checked').should.be.true

    checkbox = React.addons.TestUtils.findRenderedDOMComponentWithTag(rendered.component, 'input').getDOMNode()

    checkbox.value = true

    React.addons.TestUtils.Simulate.change checkbox

    changed.should.be.true

  it 'should support nested components', ->

    rendered = renderIntoDocument Checkbox {},
      React.DOM.p { className: 'help-block' }, 'HELP!'

    rendered.$el.should.have 'p.help-block'

  it 'should show a validation error if provided', ->

    rendered = renderIntoDocument Checkbox
      validationError: 'This field is invalid'

    rendered.$el.should.have.class 'has-error'
