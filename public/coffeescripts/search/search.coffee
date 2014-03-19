onWindowResize = ->
  $main = $("#main-columns")
  if $main.length
    $left  = $("#main-columns > .left")
    $tabs  = $(".nav.nav-tabs", $left)
    $tabsContent = $(".tab-content", $left)
    
    $right = $("#main-columns > .right")
    $header = $("#header")
    $footer = $("#footer")
    
    height = $(window).height() - $header.height() - $footer.height() - 42
    $main.height(height)
    
    height = $left.height() - $tabs.height()
    $tabsContent.height(height)

$ ->
  # resize
  onWindowResize()
  $(window).on 'resize', onWindowResize
  
  require [
    'views/search/search'
  ], (SearchView) ->
    searchView = new SearchView
  
  
  return true
