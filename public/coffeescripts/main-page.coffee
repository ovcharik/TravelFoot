$ ->
  
  onWindowResize = ->
    height = $(window).height() - $header.height() - $footer.height() - 42
    $main.height(height)
    
    height = $left.height() - $tabs.height()
    $tabsContent.height(height)
  
  # init
  $main  = $("#main-columns")
  if $main.length
    $left  = $("#main-columns > .left")
    $tabs  = $(".nav.nav-tabs", $left)
    $tabsContent = $(".tab-content", $left)
    
    $right = $("#main-columns > .right")
    
    $header = $("#header")
    $footer = $("#footer")
    
    onWindowResize()
    
    $(window).on 'resize', onWindowResize
  
  return true
