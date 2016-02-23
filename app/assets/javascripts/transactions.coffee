@module 'Transactions', ->
  @module 'Form', ->
    @init =->
      $('#transaction_categories').select2 theme: 'bootstrap'

      $('.datepicker').datepicker
        format: 'dd/mm/yyyy'
        weekStart: 1
        clearBtn: true
        todayHighlight: true
      $('.wysihtml5').each (i, elem) ->
        $(elem).wysihtml5()

  @module 'GoogleChart', ->
    @init =->
      drawChart = ->
        data = google.visualization.arrayToDataTable(gon.expenditures_by_category)
        options =
          title: 'Expenditures by category for current month'
          is3D: true
        chart = new (google.visualization.PieChart)(document.getElementById('piechart_3d'))
        chart.draw data, options
        return

      google.charts.load 'current', packages: [ 'corechart' ]
      google.charts.setOnLoadCallback drawChart

  @module 'Autocomplete', ->
    @init = (elem, data) ->
      $(elem).autocomplete(
        source: data
        minLength: 0
        scroll: true
      ).focus ->
        $(@).autocomplete "search", ""
        return

$ ->
  Transactions.Form.init() if $('#transaction_form').length
  Transactions.GoogleChart.init() if $('#piechart_3d').length
  Transactions.Autocomplete.init('#transaction_category_name', gon.user_categories) if $('#transaction_category_name').length
