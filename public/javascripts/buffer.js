  $(function() {
    $('#search-form').submit(function() {
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
            $form.trigger('reset');
            var output = []
            for (var i in data.results){
              output.push(data.results[i].name+'<br>')
            }
            $('#results').html(output);
						$('#results_error').hide();
						$('#results').show();

					} else {
						var errString="Errors <br>";
						for (var i=0; i<data.errors.length; i++){
							errString+="<br>"+data.errors[i];
						};
						$('#results_error').html(errString);
						$('#results').hide();
						$('#results_error').show();
					};
				return $button.prop('disabled', false);
				},
				error: function() {
          return $button.prop('disabled', false);
				}
      })
      return false;
    });
});
