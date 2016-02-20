//= require_tree ../../../vendor/assets/javascripts/charts/.

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

$ ->
  Transactions.Form.init() if $('#transaction_form').length
  Transactions.GoogleChart.init() if $('#piechart_3d').length
