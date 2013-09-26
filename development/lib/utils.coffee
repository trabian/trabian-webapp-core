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
