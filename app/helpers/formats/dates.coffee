module.exports =

  format: (date, format, utc = false) ->

    try
      if utc
        moment.utc(date).format format
      else
        moment(date).format format
    catch error
      console.log "Error formatting date", error
      return date

  shortFormat: (date) ->
    @format date, if moment(date).isSame moment(), 'year'
      'M/D'
    else
      'M/D/YY'

  shortFormatWithYear: (date) -> @format date, 'M/D/YYYY'
  shortFormatWithShortYear: (date) -> @format date, 'M/D/YYYY'

  toJSON: (date) -> @format date

  longFormat: (date, options = {}) ->
    dayFormat = if options?.shortDay? then 'ddd' else 'dddd'
    @format date, "#{dayFormat}, MMMM Do, YYYY", options.utc

  monthDayYear: (date) -> @format date, 'MMM Do, YYYY'
