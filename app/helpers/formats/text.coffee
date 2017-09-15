module.exports =

  # Taken from Rails: https://github.com/rails/rails/blob/master/activesupport
  # /lib/active_support/inflector/transliterate.rb#L80
  parameterize: (original, sep = '-') ->

    sepRe = new RegExp sep

    escapedSeparator = sep.replace /([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1"

    out = original.replace /[^a-z0-9\-_]+/gi, sep

    unless _.isEmpty sep

      dupExp = ///
        #{escapedSeparator}
        {2,} # Group multiples
      ///gi

      outerExp = ///
        ^#{escapedSeparator} # Leading separator
        | #{escapedSeparator}$ # Trailing separator
      ///gi

      # Remove separator duplicates
      out = out.replace(dupExp, sep)
        # Remove leading/trailing separator
        .replace(outerExp, '')

    out.toLowerCase()

  maskId: (value, stars = 4, revealed = 4, unmaskIfShort = false) ->

    if value
      value = "#{value}"

      if unmaskIfShort and value.length <= revealed
        value
      else
        "#{Array(stars+1).join('*')}#{value.slice value.length - revealed}"

  titleize: (original) ->

    original.replace /\w\S*/g, (txt) ->
      txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()

  addLineBreaks: (original) ->

    original?.replace /\n/g, '<br />'

  truncate: (original, length, truncateStr = "...") ->
    return unless original
    return original if original.length <= length

    original.slice(0, length) + truncateStr

  pluralize: (count, singular, plural="#{singular}s") ->

    switch +count
      when 0
        "No #{plural}"
      when 1
        "#{count} #{singular}"
      else
        "#{count} #{plural}"

  # taken from underscore.string
  stripTags: (original) ->
    return '' unless original
    String(original).replace /<\/?[^>]+>/g, ''

  formatPhoneNumber: (original) ->
    return '' unless original
    onlyNumbers = ('' + original).replace(/\D/g, '')
    match = onlyNumbers.match(/^(\d{3})(\d{3})(\d{4})$/)
    if match
      "#{match[1]}-#{match[2]}-#{match[3]}"
    else
      ""
