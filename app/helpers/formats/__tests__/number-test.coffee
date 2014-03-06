{ currency, numberWithDelimiter, parseCurrency, percentage, ordinal } = require('core/helpers/formats').number

describe 'Number formatters', ->

  describe 'currency', ->

    it 'should support simple currency formatting', ->

      currency(1).should.equal '$1.00'
      currency(1.23).should.equal '$1.23'
      currency(1234.56).should.equal '$1,234.56'

    it 'should place the sign to the left of the $', ->

      currency(-1234.56).should.equal '-$1,234.56'

    it 'should support removing the cents', ->

      currency(1234.56, false).should.equal '$1,235'

  describe 'parseCurrency', ->

    it 'should properly parse various currency strings', ->

      parseCurrency('$1,234.56').should.equal 1234.56
      parseCurrency('-$1,234.56').should.equal -1234.56
      parseCurrency('$1,234.00').should.equal 1234

  describe 'numberWithDelimiter', ->

    numberWithDelimiter(1234.5610).should.equal '1,234.56'
    numberWithDelimiter(1234.56).should.equal '1,234.56'
    numberWithDelimiter(1234.56, 0).should.equal '1,235'

  describe 'percentage', ->

    it 'should handle numbers', ->
      percentage(0.0123).should.equal '1.23%'
      percentage(1.23).should.equal '1.23%'
      percentage(1.23, true).should.equal '123.00%'

    it 'should handle strings', ->

      percentage('0.0123').should.equal '1.23%'
      percentage('1.23%').should.equal '1.23%'

  describe 'ordinal', ->

    it 'should convert a number to its ordinal version', ->

      ordinal(1).should.equal '1st'
      ordinal(2).should.equal '2nd'
      ordinal(3).should.equal '3rd'
      ordinal(4).should.equal '4th'
      ordinal(5).should.equal '5th'
      ordinal('31').should.equal '31st'
