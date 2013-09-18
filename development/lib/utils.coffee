module.exports =

  pathRegexp: (path, keys, sensitive, strict) ->

    return path if path instanceof RegExp

    if Array.isArray(path)
      path = "(#{path.join '|'})"

    path = path
      .concat(if strict then '' else '/?')
      .replace(/\/\(/g, '(?:/')
      .replace(/(\/)?(\.)?:(\w+)(?:(\(.*?\)))?(\?)?(\*)?/g, (_, slash, format, key, capture, optional, star) ->

        keys.push
          name: key
          optional: !! optional

        slash = slash or ''

        return '' +
          (if optional then '' else slash) +
          '(?:' +
          (if optional then slash else '') +
          (format || '') + (capture || (format && '([^/.]+?)' || '([^/]+?)')) + ')' +
          (optional || '') +
          (if star then '(/*)?' else '')

      )
      .replace(/([\/.])/g, '\\$1')
      .replace /\*/g, '(.*)'

    new RegExp "^#{path}(?=\\?|$)", if sensitive then '' else 'i'

  # Returns a hash with query parameters from a query string
  # Taken from Chaplin
  parseQueryString: (queryString) ->
    params = {}
    return params unless queryString
    pairs = queryString.split '&'
    for pair in pairs
      continue unless pair.length
      [field, value] = pair.split '='
      continue unless field.length
      field = decodeURIComponent field
      value = decodeURIComponent value
      current = params[field]
      if current
        # Handle multiple params with same name:
        # Aggregate them in an array.
        if current.push
          # Add the existing array.
          current.push value
        else
          # Create a new array.
          params[field] = [current, value]
      else
        params[field] = value

    params
