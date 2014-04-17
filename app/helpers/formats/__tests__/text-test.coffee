formats = require 'core/helpers/formats'

describe 'Text formatters', ->

  # The test cases are taken from the Rails tests to verify compliance:
  # https://github.com/rails/rails/blob/master/activesupport/test/inflector_test_cases.rb
  describe 'parameterize', ->

    it 'should use dashes by default', ->

      cases =
        "Donald E. Knuth": "donald-e-knuth"
        "Random text with *(bad)* characters": "random-text-with-bad-characters"
        "Allow_Under_Scores": "allow_under_scores"
        "Trailing bad characters!@#": "trailing-bad-characters"
        "!@#Leading bad characters": "leading-bad-characters"
        "Squeeze   separators": "squeeze-separators"
        "Test with + sign": "test-with-sign"

      for original, expected of cases
        formats.text.parameterize(original).should.equal expected

    it 'should handle no separator', ->

      cases =
        "Donald E. Knuth": "donaldeknuth"
        "With-some-dashes": "with-some-dashes"
        "Random text with *(bad)* characters": "randomtextwithbadcharacters"
        "Trailing bad characters!@#": "trailingbadcharacters"
        "!@#Leading bad characters": "leadingbadcharacters"
        "Squeeze   separators": "squeezeseparators"
        "Test with + sign": "testwithsign"

      for original, expected of cases
        formats.text.parameterize(original, '').should.equal expected

    it 'should keep underscores', ->

      cases =
        "Donald E. Knuth": "donald_e_knuth"
        "Random text with *(bad)* characters": "random_text_with_bad_characters"
        "With-some-dashes": "with-some-dashes"
        "Retain_underscore": "retain_underscore"
        "Trailing bad characters!@#": "trailing_bad_characters"
        "!@#Leading bad characters": "leading_bad_characters"
        "Squeeze   separators": "squeeze_separators"
        "Test with + sign": "test_with_sign"

      for original, expected of cases
        formats.text.parameterize(original, '_').should.equal expected

  describe 'addLineBreaks', ->

    it 'should handle single lined text without change', ->
      formats.text.addLineBreaks('Single Line').should.equal 'Single Line'

    it 'should convert line breaks to <br />s', ->
      formats.text.addLineBreaks('Multiple Lines\nIn this one').should.equal 'Multiple Lines<br />In this one'
