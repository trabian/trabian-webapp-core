Input = require 'core/components/bootstrap/form/input'

describe 'Input component', ->

  it 'should be a component', ->

    rendered = renderIntoDocument Input()

    rendered.$el.should.be.ok

  it 'should wrap the input (and label) in a form-group', ->

    rendered = renderIntoDocument Input()

    rendered.$el.should.be '.form-group'

  it 'should render an input based on the type passed', ->

    rendered = renderIntoDocument Input
      type: 'text'

    rendered.$el.should.have 'input[type=text]'

    rendered = renderIntoDocument Input()

    rendered.$el.should.have 'input[type=text]'

    rendered = renderIntoDocument Input
      type: 'password'

    rendered.$el.should.have 'input[type=password]'

  it 'should render a label iff a label is provided', ->

    rendered = renderIntoDocument Input()

    rendered.$el.should.not.have 'label'

    rendered = renderIntoDocument Input
      label: 'Some Label'

    rendered.$el.should.have 'label'
    rendered.$el.find('label').should.contain 'Some Label'

  it 'should support label properties if the label is an object', ->

    rendered = renderIntoDocument Input
      label:
        text: 'Some Label Text'
        className: 'some-class'

    rendered.$el.should.have 'label.some-class'

    rendered.$el.find('label').should.contain 'Some Label Text'

  it 'should assign an id to the input to match the label', ->

    rendered = renderIntoDocument Input
      label: 'Some Label'

    id = rendered.$el.find('input').attr 'id'

    id.should.be.ok

    id.should.equal rendered.$el.find('label').attr 'for'

    rendered = renderIntoDocument Input
      label: 'Some Label'
      id: 'my-custom-id'

    rendered.$el.find('input').should.have.attr 'id', 'my-custom-id'
    rendered.$el.find('label').should.have.attr 'for', 'my-custom-id'

  it 'should set a value and onChange on the input if provided', ->

    changed = false

    rendered = renderIntoDocument Input
      value: 'testing'
      onChange: ->
        changed = true

    rendered.$el.find('input').val().should.equal 'testing'

    inputField = ReactTestUtils.findRenderedDOMComponentWithTag(rendered.component, 'input').getDOMNode()

    inputField.value = 'some new value'

    ReactTestUtils.Simulate.input inputField

    changed.should.be.true

  it 'should set a valueLink on the input if provided', ->

    changed = false

    rendered = renderIntoDocument Input
      valueLink:
        value: 'testing'
        requestChange: ->
          changed = true

    rendered.$el.find('input').val().should.equal 'testing'

    inputField = ReactTestUtils.findRenderedDOMComponentWithTag(rendered.component, 'input').getDOMNode()

    inputField.value = 'some new value'

    ReactTestUtils.Simulate.input inputField

    changed.should.be.true

  it 'should support nested components', ->

    rendered = renderIntoDocument Input {},
      React.DOM.p { className: 'help-block' }, 'HELP!'

    rendered.$el.should.have 'p.help-block'

  it 'should support focus on render', ->

    { $el } = renderIntoDocument Input {}

    $el.find('input')[0].should.not.equal document.activeElement

    { $el } = renderIntoDocument Input
      autoFocus: true

    $el.find('input')[0].should.equal document.activeElement

  it 'should show a validation error if provided', ->

    rendered = renderIntoDocument Input
      validationError: 'This field is invalid'

    rendered.$el.should.have.class 'has-error'
