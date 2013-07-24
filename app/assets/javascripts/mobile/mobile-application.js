(function() {
	var updatePage = function(element, idx) {
		console.log(idx);
		$(element).siblings('.pagination')
			.children().removeClass('current')
				.eq(idx).addClass('current');
	};
	
	$(document).on('swipeleft', '.image-flicker figure', function(e) {
		if($(this).siblings('figure').length > 0) {
			var next = $(this).hide().next('figure');
			if(next.length == 0) {
				next = $(this).siblings('figure:first');
			}
			updatePage(this, next.show().index());
		}
	});

	$(document).on('swiperight', '.image-flicker figure', function(e) {
		if($(this).siblings('figure').length > 0) {
			var next = $(this).hide().prev('figure');
			if(next.length == 0) {
				next = $(this).siblings('figure:last');
			}
			updatePage(this, next.show().index());
		}
	});
})();

$(document).bind('pageshow', function() {
	// Google analytics, do NOT remove :)
	// This will fail intentionally on first load, since the google analytics code wont be in place yet.
	// That is good, or else we would have double tracking
	try { _gat._getTracker('UA-1729705-6')._trackPageview(); }
	catch(err) {}
	
	// Load user data for navigation links and flash messages.
  // On cached pages the user data is retrieved by ajax.
  // On dynamic pages the user data will be present as HTML5 data attributes.

	// Parse templates and append to #user-links and #messages
	var addUserData = function(data) {
    // $('#user-links-tmpl').tmpl(data.user).appendTo('#user-links');
    if (data.flash) {
      $('.messages-tmpl:first').tmpl(data.flash).appendTo('.ui-page-active aside.messages').hide().slideDown();
    }
  };
	$.ajax({
	  type: 'GET',
	  dataType: 'json',
	  url: '/users/current',
	  success: addUserData
	});
});
