@module 'Notifications', ->
  flash = (type, message, node = '#flash_message')->
    if message instanceof Array
      message = message.map((m) ->
        '<li>' + m + '</li>'
        ).join(",").replace( /,/g, "" )

    $(node).find('div').remove()
    $(node).prepend(
      '<div class="center alert fade in alert-'+ type +
      '"><button class="close" data-dismiss="alert">×</button>' + message +
      '</div>'
      )

  @success = (message, node)->
    flash('success', message, node)

  @error = (message, node)->
    flash('danger', message, node)
