module.exports =

  classMixin: (mixins...) ->

    for mixin in mixins

      arrayProperties = ['relations']
      objectProperties = ['defaults', 'defaultLinks', 'validation']

      _(@prototype).extend _(mixin).omit arrayProperties.concat objectProperties

      for arrayProperty in arrayProperties

        if newValue = mixin[arrayProperty]

          @prototype[arrayProperty] =
            @prototype[arrayProperty]?.concat(newValue) or newValue

      for objectProperty in objectProperties

        if newValue = mixin[objectProperty]
          _(@prototype[objectProperty] ?= {}).extend newValue

