$('.files').ready(function() {
	
	var removeButton = $('<a>', {
			text: mime.t('media._destroy'),
			css: {
				cursor: 'pointer'
			},
			click: function() {
				if($(this).text() == mime.t('media._destroy')) {
					$(this).text(mime.t('media.un_destroy'));
					$(this).parent().siblings().animate({ opacity: 0.3 }, 1000);
				}
				else {
					$(this).text(mime.t('media._destroy'));
					$(this).parent().siblings().animate({ opacity: 0.999999}, 1000);
				}
			}
		});
	
	$('.files input[type="checkbox"]').each(function() {
		var cb = $(this);
		cb.parent().hide() // hide label, which contains the checkbox
			.parent() // li
				.append(removeButton.clone(true).click(function() {
					cb.attr('checked', !cb.is(':checked'));
				}));
	});
	
	$('.files li.remove').each(function() {
		$(this).append();
	});
});
