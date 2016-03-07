@module 'Notifications', ->
  flash = (type, message, node = '#flash_message')->
    $(node).find('div').remove()
    $(node).prepend JST['templates/notification_messages']({ type: type, messages: message })

  @success = (message, node)->
    flash('success', message, node)

  @error = (message, node)->
    flash('danger', message, node)
