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

      saveModel.call(@props.model).then =>
        @onSave?()
      .fail (response) =>

        console.warn 'failed on submit', arguments, _.result @props.model, 'url'

        if @isMounted()

          if message = response.responseJSON?.error?.message or
              response.responseJSON?.data?.error?.message

            @setState
              errorMessage: message

      .always =>

        if @isMounted()
          @setState
            saving: false
            showValidationIssues: false

  renderErrorMessage: ->

    if @state.errorMessage

      React.DOM.p
        className: 'alert alert-danger'
      , @state.errorMessage

