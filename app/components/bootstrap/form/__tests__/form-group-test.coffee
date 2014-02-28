FormGroup = require 'core/components/bootstrap/form/form-group'

describe 'FormGroup component', ->

  it 'should have the "form-group" class', ->

    { $el } = renderIntoDocument FormGroup()

    $el.should.have.class 'form-group'

  it 'should merge a className passed as a property', ->

    { $el } = renderIntoDocument FormGroup
      className: 'some-class'

    $el.should.have.class 'form-group'
    $el.should.have.class 'some-class'

  it 'should include children', ->

    { $el } = renderIntoDocument FormGroup {}, [
      React.DOM.span { className: 'sample-child' }
    ]

    $el.should.have 'span.sample-child'

  it 'should have class of "has-error" if validation error is present', ->

    { $el } = renderIntoDocument FormGroup
      validationError: 'Some validation error'

    $el.should.have.class 'has-error'

  it 'should append the error if present', ->

    { $el } = renderIntoDocument FormGroup
      validationError: 'Some validation error'
    ,
      React.DOM.span { className: 'sample-child' }

    $span = $el.find '.sample-child'
    $errorMessage = $el.find '.help-block'

    $errorMessage.should.exist
