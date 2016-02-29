@module 'Transactions', ->
  @module 'Form', ->
    @init =->
      $('.datepicker').datepicker
        format: 'dd/mm/yyyy'
        weekStart: 1
        clearBtn: true
        todayHighlight: true
      $('.wysihtml5').each (i, elem) ->
        $(elem).wysihtml5()


  @module 'Autocomplete', ->
    @init = (elem, data) ->
      $(elem).autocomplete(
        source: data
        minLength: 0
        scroll: true
      ).focus ->
        $(@).autocomplete "search", ""
        return

  @module 'Index', ->
    @init =->
      table = initDatatable()
      initDelete(table)

    initDatatable = ->
      $(".datatable table").DataTable({
        aLengthMenu: [[10, 25, 50, 100, -1], [10, 25, 50, "All"]],
        order: [[2, 'desc']],
        columnDefs: [{ orderable: false, targets: [5] }],
        processing: true,
        serverSide: true,
        ajax:
          url: $(@).data('source')
      })

    initDelete = (table) ->
      $(".datatable#transactions").on 'click', "a.delete-transaction-js", (e) ->
        e.preventDefault()
        self = $(@)
        if confirm('Are you sure you want to delete this Transaction?')
          $.ajax
            method: 'DELETE'
            url: self.attr('href')
            success: (data) ->
              Notifications.info(data.success)
              table.ajax.reload()
            error: (xhr, ajaxOptions, thrownError) ->
              response = $.parseJSON(xhr.responseText)
              Notifications.info(response.error)


$ ->
  Transactions.Form.init() if $('#transaction_form').length
  Transactions.Index.init() if $('.datatable').length
  GoogleChart.init() if $('#piechart_3d').length
  Transactions.Autocomplete.init('#transaction_category_name', gon.user_categories) if $('#transaction_category_name').length
