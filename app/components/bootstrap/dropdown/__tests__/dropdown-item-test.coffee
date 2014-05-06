describe 'DropdownItem', ->

  it 'should create a listitem with the included children', ->

    { DropdownItem } = require '../index'

    { $el } = renderIntoDocument DropdownItem {},
      'Testing'

    $el.should.be 'li'

    $el.should.have 'a'

    $el.find('a').text().should.equal 'Testing'
