
  $(function() {
    return $('#search-form').submit(function() {
      var $button, $form;
      $form = $(this);
      $button = $('button[type=submit]', $form);
      $button.prop('disabled', true);
      $.ajax({
        method: $form.attr('method'),
        url: $form.attr('action'),
        data: $form.serialize(),
        dataFormat: 'JSON',
        success: function(data) {
          if (data.error) {
            console.error(data.error);
          } else {
            console.log({
              "result": data.results
            });
          }
          return $button.prop('disabled', false);
        },
        error: function(a, b, c) {
          console.error(a, b, c);
          return $button.prop('disabled', false);
        }
      });
      return false;
    });
  });
