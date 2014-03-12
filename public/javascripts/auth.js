
  $(function() {
    $('#signin-form').submit(function() {
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
          if (data.success) {
            window.location.reload();
          } else {
            $('.error', $form).slideDown();
          }
          return $button.prop('disabled', false);
        },
        error: function() {
          return $button.prop('disabled', false);
        }
      });
      return false;
    });
    return $('#signup-form').submit(function() {
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
          var $alert, $errors, error, field, _ref;
          if (data.success) {
            window.location.pathname = '/';
          } else {
            $alert = $('.alert', $form);
            $errors = $('.errors', $form);
            $errors.html('');
            _ref = data.errors;
            for (field in _ref) {
              error = _ref[field];
              $errors.append("<li><b>" + field + "</b> " + error.message + "</li>");
            }
            $alert.slideDown();
          }
          return $button.prop('disabled', false);
        },
        error: function() {
          return $button.prop('disabled', false);
        }
      });
      return false;
    });
  });
