{ DropdownItem } = require 'core/components/bootstrap/dropdown'

describe 'DropdownItem', ->

  it 'should create a listitem with the included children', ->

    { $el } = renderIntoDocument DropdownItem {},
      'Testing'

    $el.should.be 'li'

    $el.should.have 'a'

    $el.find('a').text().should.equal 'Testing'
