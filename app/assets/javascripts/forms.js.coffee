@module 'Forms', ->
  @submitting = (form_id, msg = '')->
    if msg.length > 0
      form_id.find('button[type=submit]').removeAttr('disabled').text(msg)
    form_id.find('input, textarea').removeClass('border-danger')
    form_id.find('small').remove()


