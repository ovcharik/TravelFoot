$ ->
  $('#search-form').submit ->
    $form   = $(@)
    $button = $('button[type=submit]', $form)
    
    $button.prop('disabled', true)
    
    $.ajax
      method: $form.attr('method')
      url:    $form.attr('action')
      data:   $form.serialize()
      dataFormat: 'JSON'
      
      success: (data) ->
        if data.error
          console.error data.error
        else
          console.log "result": data.results
        $button.prop('disabled', false)
      
      error: (a, b, c) ->
        console.error a, b, c
        $button.prop('disabled', false)
    
    return false
