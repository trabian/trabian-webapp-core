module.exports =

  bindValidations: (model) ->

    model.on 'validated:invalid', (model, errors) =>
      @setState { errors }
    , this

    model.on 'validated:valid', =>
      @setState errors: null
    , this

  getInitialState: ->
    saving: false

  getError: (key) ->
    return unless @state?.showValidationIssues
    @state?.errors?[key]

  submit: (e) ->

    e?.preventDefault()

    @setState
      showValidationIssues: true
      errorMessage: null

    if @props.model.isValid true

      @setState
        saving: true

      saveModel = @saveModel or @props.model.save

      @beforeSave?()

      saveModel.call(@props.model).then =>
        @onSave?()
      .fail (errorMessage) =>

        if @isMounted()

          @setState { errorMessage }

      .always =>

        if @isMounted()
          @setState
            saving: false
            showValidationIssues: false

  renderErrorMessage: ({ rawHTML } = {}) ->

    if @state.errorMessage

      if rawHTML

        React.DOM.p
          className: 'alert alert-danger'
          dangerouslySetInnerHTML:
            __html: @state.errorMessage

      else

        React.DOM.p
          className: 'alert alert-danger'
        , @state.errorMessage
