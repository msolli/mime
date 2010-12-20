$(function() {
	var settings = {
				browse_button:				'file-upload-button',
				container:						'upload-container',
				filters:							[
					{title: 'Bilder', extensions: 'jpg,jpeg,gif,png'}
				],
				flash_swf_url:				'/lib/plupload/js/plupload.flash.swf',
				headers:							{
					'X-IS-PLUPLOAD': true
				},
				max_file_size:				'10mb',
				multipart_params:			{
					authenticity_token: jQuery('meta[name="csrf-token"]').attr('content'),
					size: '250x200',
					format: 'json'
				},
				runtimes:							'html5,flash,silverlight,html4',
				silverlight_xap_url:	'/lib/plupload/js/plupload.silverlight.xap',
				url:									'/medias'
			},
			upload_button = $('#file-upload-button');
	
	session_key = jQuery('#session_key_name');
	settings.multipart_params[session_key.attr('name')] = session_key.val();
	
	if(upload_button.length > 0) {
		var	uploader = new plupload.Uploader(settings);
		
		uploader.bind('PostInit', function() { // This is added merely to allow testing :/
			$('#upload-container').find('input[type="file"]').attr('name', 'file-uploader');
		});
	
		uploader.init();
	
		// Resize the li and make it fake hover on the button (don't know why we need to do this,
		// but hover on the button isn't triggered)
		$('#upload-container')
			.width(upload_button.outerWidth() + 5)
			.height(upload_button.outerHeight())
			.hover(function() {
				upload_button.addClass('hover');
			},
			function() {
				upload_button.removeClass('hover');
			}
		);
	
		// Start uploading as soon as files are added
		uploader.bind('FilesAdded', function(up, files) {
			$.each(files, function(idx) {
				var	li = $('.files ol li:has(ol):last');
						
				if(li.find('.image.empty').length == 0) {
					li = mime.tools.input_cloner(li);
				}
				
				li.css('opacity', 0)
					.attr('data-file_id', this.id)
					.find('ol')
						.find('.boolean')
							.remove()
							.end()
						.find('.progressbar')
							.remove()
							.end()
						.append(
							$('<li>', {
								'class': 'progressbar',
								css: {
									'float': 'none',
									clear: 'both'
								}
							}).append('<img src="/images/uploader/animert-loader.gif">')
						)
						.end()
					.find('.image')
						.removeClass('empty')
						.find('img')
							.attr('src', 'http://dummyimage.com/150x150&text=Bildet+laster...')
							.attr('alt', this.name);
			});
			
			uploader.start();
		});
		
		var find_file_li = function(file_id) {
			return $('.files li[data-file_id="'+file_id+'"]');
		};
		
		uploader.bind('FileUploaded', function(up, file, response) {
			var	resp	= $.parseJSON(response.response),
					li		= find_file_li(file.id);
			
			li.find('.progressbar')
					.remove()
					.end()
				.find('img')
					.attr('src', resp.url)
					.end()
				.find('.file-id').val(resp.obj._id);
			$('#media-files').val($('#media-files').val() + ' ' + resp.obj._id);
		});
		uploader.bind('UploadProgress', function(up, file) {
			find_file_li(file.id).css('opacity', file.percent / 100);
		});
	}
});