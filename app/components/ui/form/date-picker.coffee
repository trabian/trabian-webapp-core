module.exports = React.createClass

  getDefaultProps: ->
    format: 'm/d/yy'

  componentWillUpdate: (nextProps) ->

    existingDate = @props.valueLink?.value
    newDate = nextProps.valueLink?.value

    unless (existingDate is newDate) or
        moment(existingDate).isSame newDate, 'day'

      @skipChangeEvent = true

      value = if (newDate and newDate isnt '')
        moment(newDate).toDate()
      else
        null

      @$el.datepicker 'setDate', value

  componentDidMount: ->

    @$el = $ @getDOMNode()

    @$el.datepicker(
      autoclose: true
      startDate: @props.startDate
      endDate: @props.endDate
      format: 'm/d/yy'
    ).on 'changeDate', (e) =>

      unless @skipChangeEvent

        @$el.val moment(e.date).format 'M/D/YY'

        @props.valueLink?.requestChange e.date

      @skipChangeEvent = false

    if value = @props.valueLink?.value
      date = moment value
      @$el.datepicker 'setDate', date.toDate()
      @$el.val date.format 'M/D/YY'

  # componentDidUpdate: (prevProps, prevState) ->
  #   value = @props.valueLink?.value

  showCalendar: ->
    @$el.datepicker 'show'

  componentWillUnmount: ->
    @$el.datepicker 'remove'

  render: ->

    value = if date = @props.valueLink?.value
      moment(date).format 'M/D/YY'

    React.DOM.input
      className: 'form-control dateselector-input'
      placeholder: @props.placeholder
      value: value
      onChange: ->
