@module 'Transactions', ->
  @module 'Index', ->
    @init =->
      table = initDatatable()
      initDelete(table)
      submitTransactionForm(table) if $('#transactions-form').length
      GoogleChart.init()

    initDatatable = ->
      $(".datatable table").DataTable({
        aLengthMenu: [[10, 25, 50, 100, -1], [10, 25, 50, "All"]],
        order: [[2, 'desc']],
        columnDefs: [{ orderable: false, targets: [5] }],
        processing: true,
        serverSide: true,
        drawCallback: (settings) ->
          $.ajax
            method: 'GET'
            url: '/transactions/data_for_chart'
            success: (data) ->
              GoogleChart.drowCharts(data.expenditures_by_category, data.balances_for_chart)
        ajax:
          url: $(@).data('source')
      })

    initDelete = (table) ->
      $("body .datatable").on 'click', "a.delete-transaction-js", (e) ->
        e.preventDefault()
        self = $(@)
        if confirm('Are you sure you want to delete this Transaction?')
          $.ajax
            method: 'DELETE'
            url: self.attr('href')
            success: (data) ->
              Notifications.success(data.success)
              table.ajax.reload()
            error: (xhr, ajaxOptions, thrownError) ->
              response = $.parseJSON(xhr.responseText)
              Notifications.error(response.error)

    # Allow Submit New Transaction form
    submitTransactionForm = (table)->
      $('#transactions-form').on 'submit', 'form', (e) ->
        e.preventDefault()
        self = $(@)

        $.ajax
          url: self.attr('action')
          dataType: 'JSON'
          method: 'POST'
          data: self.serialize()
          success: (data) ->
            $('#transactions-form').modal('hide')
            Notifications.success(data.success)
            table.ajax.reload()
          error: (xhr, ajaxOptions, thrownError) ->
            $('#transactions-form').find('input, textarea').removeClass('border-danger')
            $('#transactions-form').find('small').remove()

            errors = $.parseJSON(xhr.responseText).errors
            errorMessage = []
            $.each errors, (key, val) ->
              $("#transaction_#{ key }").addClass('border-danger').before JST['templates/field_errors']({ errors: val.join(", ") })
              i = 0
              while i < val.length
                errorMessage.push( key.charAt(0).toUpperCase() + key.slice(1) + ": " + val[i] )
                i++
              return
            Notifications.error(errorMessage, '#error_explanation')

$ ->
  Transactions.Index.init() if $('body#transactions-index').length

