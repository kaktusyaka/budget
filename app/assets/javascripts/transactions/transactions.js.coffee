@module 'Transactions', ->
  @module 'Index', ->
    @init =->
      table = initDatatable()
      initDelete(table)
      submitTransactionForm(table) if $('#transactions-form').length
      GoogleChart.init()
      Datepicker.init()
      initFilters(table)

    initFilters = (table) ->
      $('.transactions #date_from, .transactions #date_to').change ->
        table.ajax.reload()

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
            url: '/transactions/chart_and_new_transaction_data'
            success: (data) ->
              $('#current_balance h2 span').text(data.current_balance)
              GoogleChart.drowCharts(data.expenditures_by_category, data.balances_for_chart)
              if data.cannot_create
                $('#new-transaction').remove()
                $('#flash_message').prepend JST['templates/transactions/cannot_create_transactions_message']({ quantity_of_transactions: data.quantity_of_transactions, pricing_plan: data.pricing_plan })

        ajax: {
          url: $(@).data('source')
          data: (d) ->
            $.extend( {}, d, {
              search_by_date_from:      $('#date_from').val()
              search_by_date_to:        $('#date_to').val()
            })
          dataSrc: (json) ->
            $(".transactions #expenditures span").text(json.expenditures_amount)
            return json.data
        }
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
            Forms.submitting(self)

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

