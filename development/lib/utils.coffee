module.exports =

  # Pulled from https://github.com/chaplinjs/chaplin/blob/master/src/chaplin/lib/utils.coffee
  queryParams:

    # Returns a query string from a hash
    stringify: (queryParams) ->
      query = ''
      stringifyKeyValuePair = (encodedKey, value) ->
        if value? then '&' + encodedKey + '=' + encodeURIComponent value else ''
      for own key, value of queryParams
        encodedKey = encodeURIComponent key
        if utils.isArray value
          for arrParam in value
            query += stringifyKeyValuePair encodedKey, arrParam
        else
          query += stringifyKeyValuePair encodedKey, value
      query and query.substring 1

    # Returns a hash with query parameters from a query string
    parse: (queryString) ->
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
