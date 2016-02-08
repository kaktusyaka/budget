@module 'Transactions', ->
  @module 'Form', ->
    @init =->
      $('#transaction_categories').select2 theme: 'bootstrap'

$ ->
  Transactions.Form.init() if $('#transaction_form').length
