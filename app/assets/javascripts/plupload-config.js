$(function() {
	var settings = {
				browse_button:				'file-upload-button',
				container:						'upload-container',
				filters:							[
					{title: 'Bilder', extensions: 'jpg,jpeg,gif,png'}
				],
				flash_swf_url:				'/lib/plupload/js/plupload.flash.swf',
				max_file_size:				'10mb',
				multipart_params:			{
					authenticity_token: jQuery('meta[name="csrf-token"]').attr('content'),
					size: '250x200',
					format: 'json',
					is_plupload: true
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
		
		upload_button.click(function() {
			uploader.start();
		});
	
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
			
			var last_id = parseInt(($('.files li textarea:last').attr('id') || "0").match(/\d+/)[0]);
			
			$.each(files, function(idx) {
				last_id = last_id + 1;
				
				var obj = {
					media_id: '',
					upload_id: this.id,
					url: 'http://dummyimage.com/150x150&text=Bildet+laster...',
					description: '',
					id: '',
					last_id: last_id
				};
				
				$('#media-template').tmpl(obj).insertBefore('#upload-button-container');
			});
			
			uploader.start();
		});
		
		var find_file_li = function(file_id) {
			return $('.files li[data-file_id="'+file_id+'"]');
		};
		
		uploader.bind('UploadProgress', function(up, file) {
			var p_holder = find_file_li(file.id).find('.progressbar');
			p_holder.find('.progress-text').html(file.percent + '%');
			p_holder.find('.progress').css('width', file.percent + '%');
			if(file.percent >= 100) {
				p_holder.find('.progress-text').html('Prosesserer…');
			}
		});
		
		uploader.bind('FileUploaded', function(up, file, response) {
			var	resp	= $.parseJSON(response.response),
					li		= find_file_li(file.id);
			
			li.find('.progressbar')
					.remove()
					.end()
				.find('.image img')
					.attr('src', resp.url)
					.end()
				.find('.file-id').val(resp.obj._id);
			$('#media-files').val($('#media-files').val() + ' ' + resp.obj._id);
		});
		uploader.bind('UploadProgress', function(up, file) {
			find_file_li(file.id).css('opacity', file.percent / 100);
		});
	}
	
	// Removal of image that haven't been saved into the article yet.
	$('.files').delegate('button.remove', 'click', function(e) {
		var	li = $(this).parents('li'),
				file_id = li.find('.file-id').val();
		
		$('#media-files').val($('#media-files').val().replace(file_id, ''));
		li.remove();
		e.stopPropagation();
		e.preventDefault();
		return false;
	});
	
});
