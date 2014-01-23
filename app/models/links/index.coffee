UriTemplate = require 'uritemplate'

module.exports =

  _buildResourceKey: (name) ->

    resourceName = _.result this, 'resourceName'

    [resourceName, name].join '.'

  _findTemplate: (key) ->

    linkName = @_buildResourceKey key

    template = @collection?.links?[linkName]

    return unless template

    # Links can be represented as either of:
    #
    #   links:
    #     'projects.todos': '/projects/{projects.ids}/todos'
    #
    # or
    #
    #   links:
    #     'projects.todos':
    #       href: '/projects/{projects.ids}/todos'
    #
    if _.isObject template
      template = template.href

    # We're currently parsing this on-demand. We could eventually cache this
    # if it causes performance issues.
    UriTemplate.parse template

  _buildTemplateVariables: (key, modelLinks) ->

    templateVars = {}

    # Collect attributes from model. For instance:
    #
    #   templateVars["projects.id"] = project.id
    #   templateVars["projects.key"] = project.get 'key'
    #
    for attrName, value of @attributes
      templateVars[@_buildResourceKey attrName] = value

    # Add any links provided at the model level. For instance:
    #
    #   projects: [
    #     id: 1
    #     links:
    #       todos: ['1', '2']
    #   ]
    #
    #   templateVars["projects.todos"] = ['1', '2']
    #
    templateVars[@_buildResourceKey key] = modelLinks

    templateVars

  getLink: (key) ->
    @get('links')?[key]

  findLink: (key) ->

    # Look for links as a direct decendent of model
    modelLinks = @getLink key

    if template = @_findTemplate key

      template.expand @_buildTemplateVariables key, modelLinks

    else
      modelLinks
