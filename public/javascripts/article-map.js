$(document).ready(function() {
	(function() {
		var map = null,
				new_width = 980,
				new_height = 500;

		$('article .meta .map-wrapper')
			.find('.map').each(function() {
				var	lat = $(this).data('lat'),
						lng = $(this).data('lng'),
						zoom = $(this).data('zoom'),
						options = {
							zoom: zoom,
							mapTypeId: google.maps.MapTypeId.ROADMAP,
							center: new google.maps.LatLng(lat, lng)
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

					var map_c = $(this).siblings('.map'), old_width = map_c.width(),
					old_height = map_c.height(),  old_left = map_c.offset().left, center = map.getCenter(),
					bigger_map_b = $(this).hide(),
					smaller_map_b = $(this).siblings('.smaller-map').show(),
					onStep = function() {
						google.maps.event.trigger(map, 'resize');
						map.panTo(center);
					};


					map_c.animate({
						left: old_left - (new_width + old_width),
						width: new_width,
						height: new_height
						}, {
							duration: 2000,
							step: onStep
					});

					var onKeyup = function(e) {
						if(e.keyCode == '27') {
							smaller_map_b.trigger('click');
						}
					};

					$('body').keyup(onKeyup).add(smaller_map_b).click(function(e) {
						e.stopPropagation();
						e.preventDefault();
						smaller_map_b.hide();
						bigger_map_b.show();
						map_c.animate({
								left: 0,
								width: old_width,
								height: old_height
							}, {
								duration: 2000,
								step: onStep
						});

						$('body').unbind('keyup', onKeyup);
						$(this).unbind('click', arguments.callee);
					});

				})
				.show();
	})();
});