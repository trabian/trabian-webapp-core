UriTemplate = require 'uritemplate'

module.exports =

  urlForRelated: (key) ->

    modelLinks = @get('links')?[key]

    resourceName = _.result this, 'resourceName'

    linkName = [resourceName, key].join '.'

    template = @collection?.links?[linkName]

    if template

      if _.isObject template
        template = template.href

      template = UriTemplate.parse template

      expansionKeys = {}

      # Collection attributes from model. For instance:
      #
      #   expansionKeys["projects.id"] = project.id
      #   expansionKeys["projects.key"] = project.get 'key'
      #
      for attrName, value of @attributes
        expansionKeys["#{resourceName}.#{attrName}"] = value

      # Add any links provided at the model level. For instance:
      #
      #   projects: [
      #     id: 1
      #     links:
      #       todos: ['1', '2']
      #   ]
      #
      #   expansionKeys["projects.todos"] = ['1', '2']
      #
      expansionKeys["#{resourceName}.#{key}"] = modelLinks

      template.expand expansionKeys

    else

      # No top-level link template is available, so use the link provided at
      # the model level (if available).
      #
      #   projects: [
      #     id: 1
      #     links:
      #       todos: '/projects/1/todos'
      #   ]
      #
      #   urlForRelated('todos') == '/projects/1/todos'
      #
      modelLinks
