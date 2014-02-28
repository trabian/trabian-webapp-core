Select2Component = require 'core/components/ui/form/select2'

describe 'Select2 Component', ->

  beforeEach ->

    @options = [
      React.DOM.option { value: 'test1' }, 'Test Option 1'
      React.DOM.option { value: 'test2' }, 'Test Option 2'
      React.DOM.option { value: 'test3' }, 'Test Option 3'
    ]

  it 'should create a <select> element', ->

    { $el } = renderIntoDocument Select2Component
      name: 'testing'
    , @options

    $el.should.be 'select'
    $el.should.have.attr 'name', 'testing'
    $el.find('option').length.should.equal 3

  it 'should add an empty option if there\'s a placeholder', ->

    { $el } = renderIntoDocument Select2Component
      name: 'testing'
      placeholder: 'Testing'
    , @options

    $el.should.be 'select'
    $el.should.have.attr 'name', 'testing'
    $el.find('option').length.should.equal 4

  it 'should set the default value if provided', ->

    { $el } = renderIntoDocument Select2Component
      name: 'testing'
      defaultValue: 'test2'
    , @options

    $el.val().should.equal 'test2'

  it 'should set a valueLink on the select if provided', ->

    changed = false

    rendered = renderIntoDocument Select2Component
      valueLink:
        value: 'test2'
        requestChange: ->
          changed = true
    , @options

    rendered.$el.val().should.equal 'test2'

    rendered.$el.val 'test3'

    React.addons.TestUtils.Simulate.change rendered.$el[0]

    changed.should.be.true
