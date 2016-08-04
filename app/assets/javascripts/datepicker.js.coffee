@module 'Datepicker', ->
  @init =->
    $('.datepicker').datepicker
      format: 'dd/mm/yyyy'
      weekStart: 1
      clearBtn: true
      todayHighlight: true
