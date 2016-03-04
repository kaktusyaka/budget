@module 'Categories', ->
  @module 'IndexSortable', ->
    @init =->
      initSortable()
      initDelete()
      loadFormToModal()
      submitCategoryForm()

    initSortable = ->
      $('#sortable').sortable
        axis: 'y'
        update: ->
          $.post($(this).data('update-url'), $(this).sortable('serialize'))

    initDelete = ->
      $("body").on 'click', ".ui-sortable li a.delete-category-js", (e) ->
        e.preventDefault()
        self = $(@)
        if confirm('Are you sure you want to delete this Category?')
          $.ajax
            method: 'DELETE'
            url: self.attr('href')
            success: (data) ->
              self.closest("li").remove()
              Notifications.success(data.success)
            error: (xhr, ajaxOptions, thrownError) ->
              response = $.parseJSON(xhr.responseText)
              Notifications.error(response.error)

    loadFormToModal = ->
      $('body').on 'click', 'a.open-category-js', (e) ->
        e.preventDefault()
        $('#categories-form').modal('show')
        $($(@).data('remote-target')).load $(@).attr('href')

      $('#categories-form').on 'hidden.bs.modal', (e) ->
        $(@).find('.modal-content').empty()


    # Allow Submit New Transaction form
    submitCategoryForm =->
      $('#categories-form').on 'submit', 'form', (e) ->
        e.preventDefault()
        self = $(@)

        $.ajax
          url: self.attr('action')
          dataType: 'JSON'
          method: 'POST'
          data: self.serialize()
          success: (data) ->
            $('#categories-form').modal('hide')
            Notifications.success(data.success)
            if self.attr('action') == "/categories"
              $(".ui-sortable li:last").after("<li class='category ui-state-default ui-sortable-handle'>
                <span class='ui-icon ui-icon-arrowthick-2-n-s'> </span> #{data.name}
                <a class='category_action delete-category-js' href='/categories/#{data.id}.json'>
                <div class='glyphicon glyphicon-remove'></div></a>
                <a data-remote-target='#categories-form .modal-content' class='open-category-js category_action' title='Edit'
                href=''/categories/#{data.id}/edit'><div class='glyphicon glyphicon-pencil'></div></a></li>")
            else
              $(".ui-sortable li#category_#{data.id}").find(".category-name").text(data.name)
          error: (xhr, ajaxOptions, thrownError) ->
            $('#categories-form').find('input').removeClass('border-danger')
            $('#categories-form').find('small').remove()

            errors = $.parseJSON(xhr.responseText).errors
            errorMessage = []
            $.each errors, (key, val) ->
              $("#category_#{ key }").addClass('border-danger').before("<small class='text-danger'>#{ val.join(", ") }</small>")
              i = 0
              while i < val.length
                errorMessage.push( key.charAt(0).toUpperCase() + key.slice(1) + ": " + val[i] )
                i++
              return
            Notifications.error(errorMessage, '#error_explanation')


$ ->
  Categories.IndexSortable.init() if $('#categories-index').length
