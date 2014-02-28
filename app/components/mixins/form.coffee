module.exports =

  bindValidations: (model) ->

    model.on 'validated:invalid', (model, errors) =>
      @setState { errors }
    , this

    model.on 'validated:valid', =>
      @setState errors: null
    , this

  getError: (key) ->
    return unless @state?.showValidationIssues
    @state?.errors?[key]

  submit: (e) ->

    e.preventDefault()

    @setState
      showValidationIssues: true

    if @props.model.isValid true

      @setState
        saving: true

      @props.model.save().then =>
        @onSave?()
      .fail =>
        console.warn 'FAIL', arguments
      .always =>

        if @isMounted()
          @setState
            saving: false
            showValidationIssues: false

