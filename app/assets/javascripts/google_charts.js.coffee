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

    drawVisualization = ->
      data = google.visualization.arrayToDataTable(gon.balances_for_chart)
      options =
        title: 'Weekly Balances for last 6 months'
        vAxis: title: 'Amount'
        hAxis: title: 'Weeks'
        seriesType: 'bars'
        series: 1: type: 'line'
      chart = new (google.visualization.ComboChart)(document.getElementById('chart_div'))
      chart.draw data, options
      return

    google.charts.load 'current', packages: [ 'corechart' ]
    google.charts.setOnLoadCallback drawChart
    google.charts.setOnLoadCallback drawVisualization

