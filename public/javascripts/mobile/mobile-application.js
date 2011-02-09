(function() {
	var updatePage = function(element, idx) {
		console.log(idx);
		$(element).siblings('.pagination')
			.children().removeClass('current')
				.eq(idx).addClass('current');
	};
	
	$('.image-flicker figure').live('swipeleft', function(e) {
		var next = $(this).hide().next('figure');
		if(next.length == 0) {
			next = $(this).siblings('figure:first');
		}
		updatePage(this, next.show().index());
	});

	$('.image-flicker figure').live('swiperight', function(e) {
		var next = $(this).hide().prev('figure');
		if(next.length == 0) {
			next = $(this).siblings('figure:last');
		}
		updatePage(this, next.show().index());
	});
})();