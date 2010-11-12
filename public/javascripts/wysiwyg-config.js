CKEDITOR.editorConfig = function( config )
{
	config.toolbar = 'mime';
	config.format_tags = 'p;h2;h3';
	config.extraPlugins = 'MediaEmbed'
	config.toolbar_mime = [
		[	'Format',
			'Bold', 'Italic', 'Underline', 'Link', 'Unlink', 'MediaEmbed', '-',
			// Leave out image for now until the server side is ready
			// 'NumberedList', 'BulletedList', 'Image', 'Table', '-', 
			'NumberedList', 'BulletedList', 'Table', '-',
			'Subscript', 'Superscript', 'Blockquote', '-',
			'Undo', 'Redo'
		]
	];
};