{ dayName } = require('core/helpers/formats').dates

describe 'Date formatters', ->

  describe 'dayName', ->

    it 'should show the day of the week', ->

      dayName(0).should.equal 'Sunday'
      dayName('0').should.equal 'Sunday'

      dayName(6).should.equal 'Saturday'
      dayName('6').should.equal 'Saturday'

      expect(dayName(7)).to.not.exist
