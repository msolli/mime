$(document).ready(function() {
  // Load user data for navigation links.
  // On cached pages the user data is retrieved by ajax.
  // On dynamic pages the user data will be present as HTML5 data attributes
  (function(){
    // Parse template and append to #user-links
    var addUserData = function(data) {
      $('#user-links-tmpl').tmpl(data).appendTo('#user-links');
    };

    var userData = $('#user-links').data('user');
    if (userData == null) {
      $.ajax({
        type: 'GET',
        dataType: 'json',
        url: '/users/current',
        success: addUserData
      });
    } else {
      addUserData(userData);
    }
  })();

  // Don't show presentation headword in edit article form if it's the same as
  // headword
  (function(){
    var headword_presentation = $("article form #article_headword_presentation");
    var headword = $("article form #article_headword");
    if (headword_presentation.length && headword.length) {
      if (headword_presentation.val().trim() == headword.val().trim()) {
        headword_presentation.val('');
      }
    }
  })();
	
	(function() {
		$('#external-links').find('button').click(function() {
	    var li = $(this).parents('ol.link').parent();

	    if($(this).hasClass('add')) {
	      mime.tools.input_cloner(li);
	    } else if($(this).hasClass('remove')) {
	      if(!li.is(':last-child')) {
	        li.remove();
	      }
	    }
	  });
	
		var	file_element = $('.files input[type="file"]'),
				commit_button = file_element.siblings('button'),
				uploadify_settings = {
					auto: true,
					fileDataName: file_element.attr('name'),
					fileExt: '*.jpg,*.jpeg,*.png,*.gif',
					hideButton: true,
					multi: true,
					script: '/medias',
					width: commit_button.outerWidth(),
					height: commit_button.outerHeight(),
					scriptData: {
						// Double encode intended
						authenticity_token: encodeURI(encodeURIComponent(jQuery('meta[name="csrf-token"]').attr('content'))),
						size: '250x200',
						format: 'json'
				  },
					queueID: 'file-upload-queue',
					sizeLimit: 1024 * 1024 * 10,
					expressInstall: '/lib/jquery.uploadify-v2.1.4/expressInstall.swf',
					uploader: '/lib/jquery.uploadify-v2.1.4/uploadify.swf',
					wmode: 'transparent',
					onComplete: function(event, id, fobj, response, data) {
						var	li = $('.files ol li:has(ol):last'),
								resp = $.parseJSON(response);
						if(li.find('.image img').attr('src')) {
							li = input_cloner(li);
						}
						
						li.find('.image img').attr('src', resp.url)
							.parent().removeClass('empty')
							.parent().find('.file-id').val(resp.obj._id);
						$('#media-files').val($('#media-files').val() + ' ' + resp.obj._id);
					},
					onProgress: function(event, id, fobj, data) {
						console.log([event, id, fobj, data]);
					},
					onInit: function() {
						file_element.parent().hover(function() {
							commit_button.addClass('hover');
						},
						function() {
							commit_button.removeClass('hover');
						}).width(commit_button.outerWidth() + 5).height(commit_button.outerHeight()); // Deliberately adding some width slack
						return true;
					}
				},

		session_key = jQuery('#session_key_name');
		uploadify_settings.scriptData[session_key.attr('name')] = encodeURI(encodeURIComponent(session_key.val()));

		file_element.uploadify(uploadify_settings);
	})();

  // jQuery.timeago() (http://timeago.yarp.com/)
  $.timeago.settings.cutoff = 7*24*60*60*1000;
  $("time.timeago").timeago();

  // Formtastic
  $('form.formtastic label abbr').html(function() {
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
  })();

  // Tooltips (http://docs.jquery.com/Plugins/tooltip)
  $('[data-tooltip-enable]').tooltip({
    layout: '<div><span/></div>',

    onBeforeShow: function() {
      var el    = this.getTrigger(),
          conf  = this.getConf();

      conf.position = ['top right'];
      conf.offset = [this.getTip().outerHeight(), 10];
    }
  });
  // Show tooltip for error fields on page load
  $('li.error [data-tooltip-enable]').focus();

  // Disable enter to submit for map search
  $('#maptastic-search').keypress(function(e) {
    if(e.which == '13') {
      e.preventDefault();
      e.stopPropagation();
      return false;
    }
  });
});
