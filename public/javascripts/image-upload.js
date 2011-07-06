var ImageUpload = (function() {

  var uploader,

  init = function() {
    var settings, session_key;
    
    $('input:submit').button();

    settings = {
      runtimes: 'html5,flash',
      browse_button: 'upload-image',
      container: 'upload-container',
      max_file_size: '10mb',
      flash_swf_url: '/lib/plupload/plupload.flash.swf',
      multi_selection: false,
      multipart_params: {
        authenticity_token: $('meta[name="csrf-token"]').attr('content')
  		},
      url: $('#upload-container').data('url'),
      filters: [
        {title: 'Bilder', extensions: 'jpg,jpeg,gif,png'}
      ],

      preinit: {
        Init: function(up, params) {
          log("Init");
          $('#upload-image').css('display', 'inline-block').button();
          $('#upload-no-support').hide();
        }
      },

      init: {
        FilesAdded: function(up, files) {
          $('#thumb-loader').show();
          $('#upload-error').hide();
          $('#upload-image').button('disable');
          uploader.start();
        },

        FileUploaded: function(up, file, response) {
          log("FileUploaded");
          log(response);
          $('#edit_image').fadeOut('fast', function() {
            $(this).html(response.response);
            $(this).fadeIn('fast');
          });
        },

        Error: function(up, error) {
          log("Error");
          log(error);
          $('#thumb-loader').hide();
          $('#upload-error-message').html(error.message);
          $('#upload-error').show();
          $('#upload-image').button('enable');
        }
      }
    };

    session_key = $('#upload-container').data('session_key');
  	settings.multipart_params[session_key] = $('#upload-container').data('session_cookie');

    uploader = new plupload.Uploader(settings);
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
