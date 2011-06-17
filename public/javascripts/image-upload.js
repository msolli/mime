var ImageUpload = (function() {

  var uploader,

  init = function() {
    $('input:submit, #upload-image').button();
    uploader = new plupload.Uploader({
      runtimes: 'html5,html4',
      browse_button: 'upload-image',
      container: 'upload-container',
      max_file_size: '10mb',
      multi_selection: false,
      multipart_params: {
        authenticity_token: $('meta[name="csrf-token"]').attr('content')
  		},
      url: $('#upload-container').data('url'),
      filters: [
        {title: 'Bilder', extensions: 'jpg,jpeg,gif,png'}
      ],

      init: {

        FilesAdded: function(up, files) {
          $('#thumb-loader').show();
          $('#upload-error').hide();
          $('#upload-image').button('disable');
          uploader.start();
        },

        FileUploaded: function(up, file, response) {
          $('#edit_image').fadeOut('fast', function() {
            $(this).html(response.response);
            $(this).fadeIn('fast');
          });
        },

        Error: function(up, error) {
          $('#thumb-loader').hide();
          $('#upload-error-message').html(error.message);
          $('#upload-error').show();
          $('#upload-image').button('enable');
        }
      }
    });
    uploader.init();

    $('form.image')
      .live('ajax:beforeSend', function(evt, xhr, settings) {
        $('#image-loader').show();
        $('span.error').remove();
      })
      .live('ajax:success', function(evt, data, status, xhr) {
      })
      .live('ajax:complete', function(evt, xhr, status) {
        $('#image-loader').hide();
      })
      .live('ajax:error', function(evt, xhr, status, error) {
        var errors,
            model;

        try {
          errors = $.parseJSON(xhr.responseText);
        } catch (err) {
          errors = { base: $('#base-errors').data('status_500') };
        }

        model = $(this).attr('id').split('_')[1];

        for (error in errors) {
          inputElement = $('#' + model + '_' + error);
          if (inputElement.length) {
              inputElement.after('<span class="error">' + errors[error] + '</span>');
          }
        }

        if (errors['base']) {
          $('#base-errors').html('<span class="error">' + errors['base'] + '</span>');
        }
      });
  };

  return {
    init: init
  };
}());


$(document).ready(function() {
  if ($('#upload-image').length == 0) {
    return;
  }

  ImageUpload.init();
});
