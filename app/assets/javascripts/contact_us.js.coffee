@module 'ContactUs', ->
  @init =->
    $('form#contact_us_form').submit (e) ->
      e.preventDefault()
      self = $(@)
      self.find('button[type=submit]').attr('disabled', 'disabled').text("Sending...")

      $.ajax
        url: 'home/send_contact_us'
        method: 'POST'
        dataType: 'JSON'
        data: self.serialize()
        success: (data) ->
          Forms.submitting(self, "Submit Message")
          Notifications.success(data.success)
          $('#contact_us_form')[0].reset()
        error: (xhr, ajaxOptions, thrownError) ->
          Forms.submitting(self, "Submit Message")

          errors = $.parseJSON(xhr.responseText).errors
          errorMessage = []
          $.each errors, (key, val) ->
            $("#contact_us_#{ key }").addClass('border-danger').before JST['templates/field_errors']({ errors: val.join(", ") })
            i = 0
            while i < val.length
              errorMessage.push( key.charAt(0).toUpperCase() + key.slice(1) + ": " + val[i] )
              i++
            return
          Notifications.error(errorMessage, '#error_explanation')
$ ->
  ContactUs.init() if $('form#contact_us_form').length
