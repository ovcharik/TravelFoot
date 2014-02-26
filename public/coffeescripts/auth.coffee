$ ->
  $('#signin-form').submit ->
    $form = $(@)
    $.ajax
      method: $form.attr('method')
      url:    $form.attr('action')
      data:   $form.serialize()
      dataFormat: 'JSON'
      success: (data) ->
        if data.success
          window.location.reload()
        else
          $('.error', $form).slideDown()
    return false
