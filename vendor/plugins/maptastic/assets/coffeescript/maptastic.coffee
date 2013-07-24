jQuery ($) ->
    $.widget "Kasmanaft.MaptasticMap",

        options:
            latitude : 'latitude'
            longitude : 'longitude'
            zoom : 'zoom'
            mapType : google.maps.MapTypeId.HYBRID
            defaultLatitude : 37.0625
            defaultLongitude : -95.677068
            defaultZoom : 4
            initialize : false
            visibilityBindings : true
            static : false


        _create: ->
            if $('#'+@options.latitude).val()!='' && $('#'+@options.longitude).val()!=''
                @marker_flag = true
                this._updateLocation [$('#'+@options.latitude).val(), $('#'+@options.longitude).val()]
            else if(!@options.static && navigator.geolocation)
                navigator.geolocation.getCurrentPosition(
                    (position)=>
                        this._updateLocation [position.coords.latitude, position.coords.longitude]
                        @zoom = 10
                    (error)->
                        # Not found in safari/iMac
                        false
                    maximumAge : Infinity
                    timeout : 10000
                )

            this._updateLocation [@options.defaultLatitude, @options.defaultLongitude] unless @latitude && @longitude

            @zoom ?= if $('#'+@options.zoom).val()!='' then parseInt($('#'+@options.zoom).val()) else @options.defaultZoom
            this._updateZoom()

            if @options.visibilityBindings
                $('#'+this.element.attr('id')+':visible').livequery ()=>
                    this.reload()
                    $('#'+this.element.attr('id')+':visible').expire()

        reload: ->
            google.maps.event.clearInstanceListeners @map if @map
            opts =
                zoom: @zoom
                mapTypeId: @options.mapType

            @map = new google.maps.Map document.getElementById(this.element.attr('id')), opts
            @map.setCenter @location
            this._setMarker(@location) if @marker_flag
            unless @options.static
                google.maps.event.addListener @map, 'click', (event)=>
                    this._updateLocation [ event.latLng.lat(), event.latLng.lng()]
                    this._setMarker event.latLng
                    @marker_flag = true
                google.maps.event.addListener @map, 'zoom_changed', =>
                    @zoom = @map.getZoom()
                    this._updateZoom()

        hide: ->
            google.maps.event.clearInstanceListeners @map
            delete @marker
            delete @map

        showAddress: (address)->
            @geocoder = new google.maps.Geocoder() unless @geocoder
            @geocoder.geocode { 'address': address }, (results, status) =>
                if status == google.maps.GeocoderStatus.OK
                    this._updateLocation [results[0].geometry.location.lat(), results[0].geometry.location.lng()]
                    @map.fitBounds results[0].geometry.viewport
                    this._setMarker @location


        _updateLocation: (location)->
            [@latitude, @longitude ] = location
            $('#'+@options.latitude).val @latitude
            $('#'+@options.longitude).val @longitude
            @location = new google.maps.LatLng @latitude, @longitude

        _updateZoom: ->
            $('#'+@options.zoom).val @zoom


        _setMarker: (location)->
            this._createMarker(location) unless @marker
            @marker.setPosition location

        _createMarker: (location)->
            @marker = new google.maps.Marker
                    map: @map
                    title: 'Drag to reposition'
                    draggable: !@options.static
            if !@options.static
                google.maps.event.addListener @marker, 'dragend', (event) =>
                        this._updateLocation [ event.latLng.lat(), event.latLng.lng()]
