var ArticleMap = (function() {
  var marker = null,
      location = null,
      map = null,

  init = function(options) {
    var zoom = null,
        map = null,
        clazz = this;

    if (! $(options.map).length) return;
    this.options = options;
    if (this.options.zoomInput == undefined) {
      this.options.zoomInput = $(this.options.map + '_attributes_zoom');
    }
    if (this.options.latInput == undefined) {
      this.options.latInput = $(this.options.map + '_attributes_latitude');
    }
    if (this.options.lngInput == undefined) {
      this.options.lngInput = $(this.options.map + '_attributes_longitude');
    }
    if (this.options.locationId == undefined) {
      this.options.locationId = $(this.options.map + '_attributes_id');
    }

    /*
     * Set up the map.
     * If the article has location, use this. Else use default values.
     */
		map = new google.maps.Map($(this.options.map)[0], {
			mapTypeId: google.maps.MapTypeId.ROADMAP,
			mapTypeControlOptions: {
				style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
			}
		});
		this.map = map;
    if (this.options.locationId.length) {
      this.location = new google.maps.LatLng(this.options.latInput.val(), this.options.lngInput.val());
      zoom = parseInt(this.options.zoomInput.val(), 10);
			this.setMarker(map, this.location);
    } else {
      var lat = $(this.options.map).data('default-lat');
      var lng = $(this.options.map).data('default-lng');
      this.location = new google.maps.LatLng(lat, lng);
      zoom = $(this.options.map).data('default-zoom');
    }
		map.setCenter(this.location);
		map.setZoom(zoom);

    /*
     * Event listeners
     *
     */
		google.maps.event.addListener(map, 'zoom_changed', function(event) {
		  $(clazz.options.zoomInput).val(map.getZoom());
 		});
 		google.maps.event.addListener(map, 'click', function(event){
 			clazz.setMarker(map, event.latLng);
 			clazz.updateInputs(event.latLng);
 		});
 		$(this.options.showMapLink).click($.proxy(this, 'showMap'));
 		$(this.options.hideMapLink).click($.proxy(this, 'hideMap'));

    /*
     * Geocoding autocomplete
     *
     */
    $(this.options.geocodingInput).autocomplete({
      source: $.proxy(this, 'findAddress'),
      minLength: 2,
      select: $.proxy(this, 'selectAddress')
    });

    /*
     * Enter in search field will not submit form
     *
     */
    $(this.options.geocodingInput).keypress(function(e) {
      if (e.which == '13') {
        e.preventDefault();
        e.stopPropagation();
        return false;
      }
    });

    /*
     * Initial state
     *
     */
    if (this.options.locationId.length) {
      $(this.options.showMapLink).click();
    } else {
      $(this.options.hideMapLink).click();
    }
  },

  setMarker = function(map, location) {
		if (!this.marker) this.createMarker(map, location);
		this.marker.setPosition(location);
	},

	createMarker = function(map, location) {
		this.marker = new google.maps.Marker({
			map: map,
			title: mime.t('article.map.drag'),
			draggable: true
		});
		var clazz = this;
		google.maps.event.addListener(this.marker, 'dragend', function(event) {
			clazz.updateInputs(event.latLng);
		});
	},

  updateInputs = function(location) {
    log("updateInputs", location);
    log(this.options.latInput);
    log(this.options.lngInput);
    log($(this.options.latInput));
    log($(this.options.lngInput));
		$(this.options.latInput).val(location.lat());
		$(this.options.lngInput).val(location.lng());
	},

  findAddress = function(request, response) {
    if (!this.geocoder) {
	    this.geocoder = new google.maps.Geocoder();
	  }
	  var geocoderRequest = {
	    address: request.term,
	    bounds: this.map.getBounds(),
	    region: 'NO'
	  };
	  this.geocoder.geocode(geocoderRequest, function(results, status) {
	    if (status == google.maps.GeocoderStatus.OK) {
        log(results);
	      response($.map(results, function(item) {
	        return {
	          label: item.formatted_address,
	          location: item.geometry.location,
	          viewport: item.geometry.viewport
	        };
        }));
      } else {
        response();
      }
	  });
  },

  selectAddress = function(event, ui) {
    log('select', ui.item.location);
    this.setMarker(this.map, ui.item.location);
    this.updateInputs(ui.item.location);
    this.map.fitBounds(ui.item.viewport);
  },

  showMap = function(event) {
    event.preventDefault();
    $(this.options.showMapLink).hide();
    $(this.options.hideMapLink).show();
    var clazz = this;
    $(this.options.map).parent().slideDown('fast', function() {
      google.maps.event.trigger(clazz.map, 'resize');
      if (clazz.marker) {
        clazz.map.setCenter(clazz.marker.getPosition());
      } else {
        clazz.map.setCenter(clazz.location);
      }
    });
  },

  hideMap = function(event) {
    event.preventDefault();
    $(this.options.hideMapLink).hide();
    $(this.options.showMapLink).show();
    var clazz = this;
    $(this.options.map).parent().slideUp('fast');
    // Clear attribute values and remove marker
    if (this.options.zoomInput.length) {
      this.options.zoomInput.val('');
    }
    if (this.options.latInput.length) {
      this.options.latInput.val('');
    }
    if (this.options.lngInput.length) {
      this.options.lngInput.val('');
    }
  };

	return {
    init: init,
    createMarker: createMarker,
    setMarker: setMarker,
    updateInputs: updateInputs,
    findAddress: findAddress,
    selectAddress: selectAddress,
    showMap: showMap,
    hideMap: hideMap
  };
}());

$(document).ready(function() {
  ArticleMap.init({
    map: '#article_location',
    showMapLink: '#show-map-link',
    hideMapLink: '#hide-map-link',
    geocodingInput: '#geocoding'
  });

  // Initialize map
  // $('.article-map').each(function() {
  //    var lat = $(this).data('lat'),
  //        lng = $(this).data('lng'),
  //        zoom = $(this).data('zoom'),
  //        options = {
  //          zoom: zoom,
  //          mapTypeId: google.maps.MapTypeId.ROADMAP,
  //          center: new google.maps.LatLng(lat, lng),
  //          mapTypeControlOptions: {
  //            style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
  //          }
  //        },
  //        marker = new google.maps.Marker({
  //          position: options.center,
  //          clickable: false
  //        }),
  //        map = new google.maps.Map($(this).get(0), options);
  //
  //    marker.setMap(map);
  // });

	(function() {
		var map = null,
				new_width = 820,
				new_height = 500;

		$('article .meta .map-wrapper')
			.find('.map').each(function() {
				var	lat = $(this).data('lat'),
						lng = $(this).data('lng'),
						zoom = $(this).data('zoom'),
						options = {
							zoom: zoom,
							mapTypeId: google.maps.MapTypeId.ROADMAP,
							center: new google.maps.LatLng(lat, lng),
							mapTypeControlOptions: {
								style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
							}
						},
						marker = new google.maps.Marker({
							position: options.center,
							clickable: false
						});
				map = new google.maps.Map($(this).get(0), options);
				marker.setMap(map);

			}).end()
			.find('a.bigger-map')
				.click(function(e) {
					e.stopPropagation();
					e.preventDefault();

					if($(this).parent().hasClass('maximized')) {
						return;
					}

					var map_c = $(this).siblings('.map'), old_width = map_c.width(),
					old_height = map_c.height(),  old_left = map_c.offset().left, center = map.getCenter(),
					smaller_map_b = $(this).siblings('.smaller-map'),
					onStep = function() {
						google.maps.event.trigger(map, 'resize');
						map.panTo(center);
					};


					map_c.animate({
						left: -530,
						width: new_width,
						height: new_height
						}, {
							duration: 1000,
							step: onStep,
							complete: function() { $(this).parent().addClass('maximized').removeClass('minimized');}
					});

					var onKeyup = function(e) {
						if(e.keyCode == '27') {
							smaller_map_b.trigger('click');
						}
					};

					$('body').keyup(onKeyup).add(smaller_map_b).click(function(e) {
						e.stopPropagation();
						e.preventDefault();

						if($(this).parent().hasClass('minimized')) {
							return;
						}
						map_c.animate({
								left: 0,
								width: old_width,
								height: old_height
							}, {
								duration: 1000,
								step: onStep,
								complete: function() { $(this).parent().addClass('minimized').removeClass('maximized');}
						});

						$('body').unbind('keyup', onKeyup);
						$(this).unbind('click', arguments.callee);
					});

				});
	})();
});