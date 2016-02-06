@module 'Categories', ->
  @module 'IndexSortable', ->
    @init =->
      $('#sortable').sortable()
      $('#sortable').disableSelection()

$ ->
  Categories.IndexSortable.init() if $('#sortable').length
