$ ->
  
  $("body").on 'click', 'a[params_safe="true"]', (event) ->
    href = event.target.href
    if href
      params = window.location.search
      url = href + params
      window.location = url
      return false
    else
      return true
