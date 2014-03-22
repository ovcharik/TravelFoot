$ ->
  
  $("body").on 'click', 'a[data-params-safe="true"]', (event) ->
    href = event.currentTarget.href
    if href
      url = href + window.location.search
      window.location = url
      return false
    else
      return true
  
  $("body").on 'click', 'a[data-confirm]', (event) ->
    $target = $(event.currentTarget)
    href = $target[0].href
    if href
      q = $target.attr("data-confirm") || "You a sure?"
      return confirm(q)
    else
      return true
