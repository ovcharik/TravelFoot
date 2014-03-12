$ ->
  $('#signin-form').submit ->
    $form = $(@)
    $button = $('button[type=submit]', $form)
    $button.prop 'disabled', true
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
        $button.prop 'disabled', false
        
      error: ->
        $button.prop 'disabled', false
    return false
  
  $('#signup-form').submit ->
    $form = $(@)
    $button = $('button[type=submit]', $form)
    $button.prop 'disabled', true
    $.ajax
      method: $form.attr('method')
      url:    $form.attr('action')
      data:   $form.serialize()
      dataFormat: 'JSON'
      success: (data) ->
        if data.success
          window.location.pathname = '/'
        else
          $alert  = $('.alert', $form)
          $errors = $('.errors', $form)
          $errors.html ''
          for field, error of data.errors
            $errors.append "<li><b>#{field}</b> #{error.type}</li>"
          $alert.slideDown()
        $button.prop 'disabled', false
        
      error: ->
        $button.prop 'disabled', false
    return false
