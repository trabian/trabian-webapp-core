module.exports =

  currency: (amount, includeCents = true) ->

    return '' unless amount
    return amount unless "#{amount}".match /^[-+]?([0-9]*|\d*\.\d{1}?\d*)$/

    precision = if includeCents then 2 else 0

    sign = if amount < 0 then '-' else ''
    "#{sign}$#{module.exports.numberWithDelimiter(Math.abs(amount), precision)}"

  parseCurrency: (amount) ->

    return 0 unless amount

    amount = String(amount).replace /[$,]/g, ''

    +amount

  numberWithDelimiter: (number, precision = 2) ->
    String(number.toFixed(precision)).replace /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,'

  percentage: (number, multiply, precision = 2) ->

    if _.isString number
      if number.match /\%/
        return number
      else
        number = +number

    unless multiply?
      multiply = number < 1

    (number * (if multiply then 100 else 1)).toFixed(precision) + "%"

  ordinal: (number) ->
    moment().lang().ordinal number
