module.exports =

  allowOnlyOne: (field) ->

    # On change of 'field', check to see if the changed model has
    # had the field set to 'true'. If so, check all the other models
    # in the collection and set the 'field' to false.
    @bind "change:#{field}", (changedModel) =>

      if changedModel.get field

        @each (model) ->
          if model.get(field) and model isnt changedModel
            model.set field, false

        @trigger "choose:#{field}", changedModel

      # else

      #   @trigger "choose:#{field}"

    @done? =>

      # After loading the collection, call the 'choose' event for the field.
      # Choosing nothing is still a choice.
      @trigger "choose:#{field}", @chooseForField field

  chooseForField: (field) ->
    @find (model) -> model.get field

  resetChoice: (field) ->
    @each (model) -> model.unset(field) if model.get field
