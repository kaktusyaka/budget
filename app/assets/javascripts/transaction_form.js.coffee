@module 'Transactions', ->
  @module 'Form', ->
    @init =->
      initTransactionLinks()

    initDatepicker = ->
      $('.datepicker').datepicker
        format: 'dd/mm/yyyy'
        weekStart: 1
        clearBtn: true
        todayHighlight: true

    initWysiwygEditor = ->
      $('.wysihtml5').each (i, elem) ->
        $(elem).wysihtml5()


    initAutocomplete = (elem, data) ->
      $(elem).autocomplete(
        source: data
        minLength: 0
        scroll: true
        close: (event, ui) ->
          $("#transaction_amount").focus()
      ).focus ->
        $(@).autocomplete "search", ""
        return

    initTransactionLinks = ->
      $('body').on 'click', 'a.open-transaction-js', (e) ->
        e.preventDefault()
        $('#transactions-form').modal('show')
        $($(@).data('remote-target')).load $(@).attr('href'), ->
          initDatepicker()
          initWysiwygEditor()
          initAutocomplete('#transaction_category_name', gon.user_categories)

      $('#transactions-form').on 'hidden.bs.modal', (e) ->
        $(@).find('.modal-content').empty()

$ ->
  Transactions.Form.init() if $('#transactions-form').length
