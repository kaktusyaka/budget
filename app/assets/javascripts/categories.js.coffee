@module 'Categories', ->
  @module 'IndexSortable', ->
    @init =->
      $('#sortable').sortable
        axis: 'y'
        update: ->
          $.post($(this).data('update-url'), $(this).sortable('serialize'))

$ ->
  Categories.IndexSortable.init() if $('#categories-index').length
