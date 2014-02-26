
  $(function() {
    return $('#signin-form').submit(function() {
      var $form;
      $form = $(this);
      $.ajax({
        method: $form.attr('method'),
        url: $form.attr('action'),
        data: $form.serialize(),
        dataFormat: 'JSON',
        success: function(data) {
          if (data.success) {
            return window.location.reload();
          } else {
            return $('.error', $form).slideDown();
          }
        }
      });
      return false;
    });
  });
