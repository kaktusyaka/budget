@module 'GoogleChart', ->
  @init =->
    google.charts.load 'current', packages: [ 'corechart' ]

  @drowCharts = (expenditures_by_category, balances_for_chart)->
    drawPieChart = ->
      data = google.visualization.arrayToDataTable(expenditures_by_category)
      options =
        title: 'Expenditures by category for current month'
        is3D: true
      chart = new (google.visualization.PieChart)(document.getElementById('piechart_3d'))
      chart.draw data, options
      return

    drawComboChart = ->
      data = google.visualization.arrayToDataTable(balances_for_chart)
      options =
        title: 'Weekly Balances for last 6 months'
        vAxis: title: 'Amount'
        hAxis: title: 'Weeks'
        seriesType: 'bars'
        series: 1: type: 'line'
      chart = new (google.visualization.ComboChart)(document.getElementById('chart_div'))
      chart.draw data, options
      return

    google.charts.setOnLoadCallback drawPieChart
    google.charts.setOnLoadCallback drawComboChart

