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

$(document).bind('pageshow', function() {
	// Load user data for navigation links and flash messages.
  // On cached pages the user data is retrieved by ajax.
  // On dynamic pages the user data will be present as HTML5 data attributes.

	// Parse templates and append to #user-links and #messages
	var addUserData = function(data) {
    $('#user-links-tmpl').tmpl(data.user).appendTo('#user-links');
    if (data.flash) {
      $('#messages-tmpl').tmpl(data.flash).appendTo('#messages').hide().slideDown();
    }
  };
	$.ajax({
	  type: 'GET',
	  dataType: 'json',
	  url: '/users/current',
	  success: addUserData
	});
});
