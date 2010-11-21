MaptasticMap = (function() {
  var	marker = null,
   		map = null,
 			geocoder = null,
			zoomElement = null,

  init = function(options) {
    this.options = options;
    var zoom = null;
    if (options.zoomInput) {
			this.zoomElement = document.getElementById(options.zoomInput);
			if(this.zoomElement) {
				zoom = parseInt(this.zoomElement.value);
			}
    }
		var map = new google.maps.Map(document.getElementById(this.options.mapId), {
			zoom: zoom || 8,
			mapTypeId: google.maps.MapTypeId.ROADMAP
		});
		this.map = map;
		this.marker = marker;
		if (document.getElementById(this.options.latInput).value && document.getElementById(this.options.lngInput).value) {
			var location = new google.maps.LatLng(document.getElementById(this.options.latInput).value, document.getElementById(this.options.lngInput).value);
			map.setCenter(location);
			this.setMarker(map, location);
		} else if (navigator.geolocation) {
  			navigator.geolocation.getCurrentPosition(function(position) {
    			initialLocation = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
    			map.setCenter(initialLocation);
  			});
		}
		var clazz = this;
		google.maps.event.addListener(map, 'zoom_changed', function(event) {
			clazz.zoomElement.value = map.getZoom();
		});
		google.maps.event.addListener(map, 'click', function(event){
			clazz.setMarker(map, event.latLng);
			clazz.updateInputs(event.latLng);
		});
		var	search = document.getElementById('maptastic-search'),
				timer = null;
		if(search) {
			search.onkeyup = function() {
				if(timer) clearTimeout(timer);
				
				timer = setTimeout(function() {
					clazz.findAddress(search.value);
				}, 800);
				
			};
		}
		
  },

  setMarker = function(map, location) {
		if (!this.marker) this.createMarker(map, location);
		this.marker.setPosition(location);
	},

	createMarker = function(map, location) {
		this.marker = new google.maps.Marker({
			map: map,
			title: 'Drag to reposition',
			draggable: true
		});
		var clazz = this;
		google.maps.event.addListener(this.marker, 'dragend', function(event) {
			clazz.updateInputs(event.latLng);
		});
	},

	updateInputs = function(location) {
		document.getElementById(this.options.latInput).value = location.lat();
		document.getElementById(this.options.lngInput).value = location.lng();
	},

	findAddress = function(address) {
	  if (!this.geocoder) {
	    this.geocoder = new google.maps.Geocoder();
	  }
	  var clazz = this;
    this.geocoder.geocode( { 'address': address }, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK && clazz.map) {
        var location = results[0].geometry.location
        clazz.map.setCenter(location);
        clazz.setMarker(clazz.map, location);
        clazz.updateInputs(location);
      } else {
        // alert("Geocode was not successful for the following reason: " + status);
      }
    });
	};

	return { // public API
    init: init,
    createMarker: createMarker,
    setMarker: setMarker,
    updateInputs: updateInputs,
    findAddress: findAddress,
    _:{ // private section, for unit tests
    }
  };

}());