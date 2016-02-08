@module 'Transactions', ->
  @module 'Form', ->
    @init =->
      $('#transaction_categories').select2 theme: 'bootstrap'
      $('.datepicker').datepicker format: 'dd/mm/yyyy'

$ ->
  Transactions.Form.init() if $('#transaction_form').length
