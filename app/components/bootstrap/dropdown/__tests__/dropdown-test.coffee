# { Dropdown, DropdownItem } = require '../index'

# describe 'Dropdown component', ->

#   it 'should create a "dropdown" div', ->

#     { $el } = renderIntoDocument Dropdown {}

#   it 'should add dropdown-related attributes to a toggle component passed via "renderToggle"', ->

#     { $el } = renderIntoDocument Dropdown
#       renderToggle: ->

#         React.DOM.h3
#           className: 'some-toggle'
#         , 'A Toggle'

#     $h3 = $el.find 'h3'

#     $h3.should.exist
#     $h3.text().should.equal 'A Toggle'
#     $h3.should.have.data 'toggle', 'dropdown'
#     $h3.should.have.class 'dropdown-toggle'
#     $h3.should.have.class 'some-toggle'

#   it 'should build a menu if children are provided', ->

#     { $el, component } = renderIntoDocument Dropdown

#       renderToggle: ->
#         React.DOM.h3 {}, 'Toggle'

#     ,

#       [

#         DropdownItem
#           key: '1'
#         , 'Item 1'

#         DropdownItem
#           key: '2'
#         , 'Item 2'

#       ]

#     $el.should.have 'ul.dropdown-menu'

#     React.addons.TestUtils.scryRenderedComponentsWithType(component, DropdownItem).should.have.length 2

