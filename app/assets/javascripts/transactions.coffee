@module 'Transactions', ->
  @module 'Form', ->
    @init =->
      $('#transaction_categories').select2 theme: 'bootstrap'
      $('.datepicker').datepicker format: 'dd/mm/yyyy'
      $('.wysihtml5').each (i, elem) ->
        $(elem).wysihtml5()

$ ->
  Transactions.Form.init() if $('#transaction_form').length
