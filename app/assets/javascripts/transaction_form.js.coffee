@module 'Transactions', ->
  @module 'Form', ->
    @init =->
      initDatepicker()
      initAutocomplete('#transaction_category_name', gon.user_categories) if $('#transaction_category_name').length

    initDatepicker = ->
      $('.datepicker').datepicker
        format: 'dd/mm/yyyy'
        weekStart: 1
        clearBtn: true
        todayHighlight: true
      $('.wysihtml5').each (i, elem) ->
        $(elem).wysihtml5()


    initAutocomplete = (elem, data) ->
      $(elem).autocomplete(
        source: data
        minLength: 0
        scroll: true
      ).focus ->
        $(@).autocomplete "search", ""
        return

$ ->
  Transactions.Form.init() if $('#transaction_form').length
