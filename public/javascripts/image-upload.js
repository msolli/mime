$(function() {
  if ($('#uploader').length == 0) {
    return;
  }

  $('#uploader').plupload({
    runtimes: 'html4',
    url: $('#uploader').data('url'),
    max_file_size: '10mb',
    filters: [
      {title: 'Bilder', extensions: 'jpg,jpeg,gif,png'}
    ]
  });
  $('#uploader_container').attr('title', '');
});
