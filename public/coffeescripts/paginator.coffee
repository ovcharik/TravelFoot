$ ->
  
  $("body").on 'click', 'a[params_safe="true"]', (event) ->
    href = event.target.href
    if href
      url = href + window.location.search
      window.location = url
      return false
    else
      return true
