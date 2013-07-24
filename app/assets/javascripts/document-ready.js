$(document).ready(function() {

  // Load user data for navigation links and flash messages.
  // On cached pages the user data is retrieved by ajax.
  // On dynamic pages the user data will be present as HTML5 data attributes.
  (function(){
    // Parse templates and append to #user-links and #messages
    var addUserData = function(data) {
      $('#user-links-tmpl').tmpl(data.user).appendTo('#user-links').hide().fadeIn('fast');
      if (data.flash) {
        $('#messages-tmpl').tmpl({ flash: data.flash }).appendTo('#messages').hide().fadeIn('fast');
      }
      for (var item in data.show) {
        $(data.show[item]).fadeIn('fast');
      }
    };
		$.ajax({
		  type: 'GET',
		  dataType: 'json',
		  url: '/users/current',
		  data: {
		    page_id: $('#edit_page_link').data('page_id')
		  },
		  success: addUserData
		});
  })();

  // jQuery.timeago() (http://timeago.yarp.com/)
  $.timeago.settings.cutoff = 7*24*60*60*1000;
  $("time.timeago").timeago();

  // Formtastic
  $('form label abbr, #jstemplates label abbr').html(function() {
    return '(' + $(this).attr('title') + ')';
  });

  // Article edit: map
  (function(){
    // Callback for show map event
    var showMap = function(event){
      event.preventDefault();
      $(this).hide();
      $('#hide-map-link').show();
      var that = this;
      $('#article_location_attributes_map').slideDown('fast', function() {
        var location, zoom;
        google.maps.event.trigger(MaptasticMap.map, 'resize');
        // Center map on default location if no location
        if (lat_input.val() == '') {
          location = new google.maps.LatLng($(that).data('default-lat'), $(that).data('default-lng'));
          zoom = $(that).data('default-zoom');
        } else {
          location = new google.maps.LatLng(lat_input.val(), lng_input.val());
          zoom = parseInt(zoom_input.val(), 10);
        }
        MaptasticMap.map.setCenter(location);
        MaptasticMap.map.setZoom(zoom);
      });
    };
    // Show map
    $('#show-map-link').click(showMap);
    // Hide map
    $('#hide-map-link').click(function(event){
      event.preventDefault();
      $(this).hide();
      $('#show-map-link').show();
      $('#article_location_attributes_map').slideUp('fast');
      // Remove attribute values - TODO: remove map marker too
      if (lat_input.length) {
        lat_input.val('');
      }
      if (lng_input.length) {
        lng_input.val('');
      }
    });

    // Initialize
    var lat_input = $('#article_location_attributes_map_latitude_input');
    var lng_input = $('#article_location_attributes_map_longitude_input');
    var zoom_input = $('#article_location_attributes_map_zoom_input');
    if (lat_input.length && lng_input.length) {
      if (lat_input.val() == '') {
        // Article does not have position
        $('#hide-map-link').hide();
      } else {
        // Article has position
        $('#show-map-link').click().hide();
      }
    }
  });

	// Only allow selecting two checkboxes at the time in version log
	(function() {
		var selector = 'table.versions input[type="checkbox"]';
		$(selector).click(function() {
			if($(selector + ':checked').length > 2) {
				alert('Du kan bare sammenligne to versjoner.');
				return false;
			}
		});
	})();

  // Datepicker
  mime.tools.addDatepicker('.date-field');

  // Disable click on TODO links
  $('a.TODO').click(function(e) {
    e.preventDefault();
  }).hover(
    function () {
      $(this).append($("<span> TODO</span>"));
    },
    function () {
      $(this).find("span:last").remove();
    });
});
