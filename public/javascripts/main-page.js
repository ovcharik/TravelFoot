
  $(function() {
    var $footer, $header, $left, $main, $right, $tabs, $tabsContent, onWindowResize;
    onWindowResize = function() {
      var height;
      height = $(window).height() - $header.height() - $footer.height() - 42;
      $main.height(height);
      height = $left.height() - $tabs.height();
      return $tabsContent.height(height);
    };
    $main = $("#main-columns");
    if ($main.length) {
      $left = $("#main-columns > .left");
      $tabs = $(".nav.nav-tabs", $left);
      $tabsContent = $(".tab-content", $left);
      $right = $("#main-columns > .right");
      $header = $("#header");
      $footer = $("#footer");
      onWindowResize();
      $(window).on('resize', onWindowResize);
    }
    return true;
  });
