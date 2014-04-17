{ calendar, dayName } = require('core/helpers/formats').dates

describe 'Date formatters', ->

  describe 'calendar', ->

    it 'should show the moment.calendar() representation', ->

      date = moment().subtract 'minutes', 10

      calendar(date).should.equal moment(date).calendar()

      dateStr = moment(date).calendar()

      dateStr = dateStr.charAt(0).toLowerCase() + dateStr.slice 1

      calendar(date, true).should.equal dateStr

  describe 'dayName', ->

    it 'should show the day of the week', ->

      dayName(0).should.equal 'Sunday'
      dayName('0').should.equal 'Sunday'

      dayName(6).should.equal 'Saturday'
      dayName('6').should.equal 'Saturday'

      expect(dayName(7)).to.not.exist
