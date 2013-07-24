CKEDITOR.editorConfig = function( config )
{
  config.entities = false;
  config.toolbar = 'mime';
  config.toolbarCanCollapse = false;
  config.disableObjectResizing = true; // resize handles i FF
  config.forcePasteAsPlainText = true; // Remove all nasty formatting
  config.format_tags = 'p;h2;h3';
  config.extraPlugins = 'mimelink';
  config.removePlugins = 'link'; // Remove link and image to avoid doubleclick actions
  config.height = 500;
  config.defaultLanguage = 'nb';
  config.docType = '<!DOCTYPE html>';
  config.contentsCss = ['http://yui.yahooapis.com/3.2.0/build/cssreset/reset-min.css', '/assets/ckeditor/contents.css'];
  config.toolbar_mime = [
    [ 'Format',
      'Bold', 'Italic', 'Underline', 'MimeLink', 'Unlink', '-',
      // Leave out image for now until the server side is ready
      // 'NumberedList', 'BulletedList', 'Image', 'Table', '-', 
      'NumberedList', 'BulletedList', 'Table', '-',
      'Subscript', 'Superscript', 'Blockquote', '-',
      'Undo', 'Redo'
    ]
  ];
};
