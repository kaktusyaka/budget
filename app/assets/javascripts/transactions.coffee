@module 'Transactions', ->
  @module 'SearchRansack', ->
    @init  =->
      $('form').on 'click', '.remove_fields', (event) ->
        $(this).closest('.form-group').remove()
        event.preventDefault()

      $('form').on 'click', '.add_fields', (event) ->
        time = new Date().getTime()
        regexp = new RegExp($(this).data('id'), 'g')
        $(this).before($(this).data('fields').replace(regexp, time))
        event.preventDefault()

  @module 'Form', ->
    @init =->
      $('#transaction_categories').select2 theme: 'bootstrap'
      $('.datepicker').datepicker format: 'dd/mm/yyyy'
      $('.wysihtml5').each (i, elem) ->
        $(elem).wysihtml5()

$ ->
  Transactions.Form.init() if $('#transaction_form').length
  RansackSearch.init() if $('#transaction_search').length
