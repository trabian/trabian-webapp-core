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
