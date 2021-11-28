/*
Document: base_js_maps.js
Author: Rustheme
Description: Custom JS code used in Maps Page
 */

var BaseJsMaps = function() {
	// Init Map with Search
	var initMapSearch = function() {
		// Init Map
		var $mapSearch = new GMaps({
			div: '#js-map-search',
			lat: 20,
			lng: 0,
			zoom: 2,
			scrollwheel: false
		});

		// When the search form is submitted
		jQuery( '.js-form-search' ).on( 'submit', function() {
			GMaps.geocode({
				address: jQuery( '.js-search-address' ).val().trim(),
				callback: function ( $results, $status ) {
					if ( ( $status === 'OK' ) && $results ) {
						var $latlng = $results[0].geometry.location;

						$mapSearch.removeMarkers();
						$mapSearch.addMarker( { lat: $latlng.lat(), lng: $latlng.lng() } );
						$mapSearch.fitBounds( $results[0].geometry.viewport );
					} else {
						alert( 'Address not found!' );
					}
				}
			});

			return false;
		});
	};

	// Init Geolocation Map
	var initMapGeo = function() {
		var gmapGeolocation = new GMaps({
			div: '#js-map-geo',
			lat: 0,
			lng: 0,
			scrollwheel: false
		});

		GMaps.geolocate({
			success: function( position ) {
				gmapGeolocation.setCenter( position.coords.latitude, position.coords.longitude );
				gmapGeolocation.addMarker({
					lat: position.coords.latitude,
					lng: position.coords.longitude,
					animation: google.maps.Animation.DROP,
					title: 'GeoLocation',
					infoWindow: {
						content: '<div class="text-success"><i class="ion-ios-location"></i> <strong>Your location!</strong></div>'
					}
				});
			},
			error: function(error) {
				alert( 'Geolocation failed: ' + error.message );
			},
			not_supported: function() {
				alert( "Your browser does not support geolocation" );
			},
			always: function() {
				// Message when geolocation succeed
			}
		});
	};

	// Init Satellite Map
	var initMapSatellite = function() {
		new GMaps({
			div: '#js-map-sat',
			lat: 0,
			lng: 0,
			zoom: 1,
			scrollwheel: false
		}).setMapTypeId( google.maps.MapTypeId.SATELLITE );
	};

	// Init Terrain Map
	var initMapTerrain = function() {
		new GMaps({
			div: '#js-map-ter',
			lat: 0,
			lng: 0,
			zoom: 1,
			scrollwheel: false
		}).setMapTypeId( google.maps.MapTypeId.TERRAIN );
	};

	// Init Overlay Map
	var initMapOverlay = function() {
		new GMaps({
			div: '#js-map-overlay',
			lat: 37.7577,
			lng: -122.4376,
			zoom: 11,
			scrollwheel: false
		}).drawOverlay({
			lat: 37.7577,
			lng: -122.4376,
			content: $( '#js-map-overlay-content' ).html()
		});
	};

	// Init Markers Map
	var initMapMarkers = function() {
		new GMaps({
			div: '#js-map-markers',
			lat: 37.7577,
			lng: -122.4376,
			zoom: 11,
			scrollwheel: false
		}).addMarkers([
			{lat: 37.70, lng: -122.49, title: 'Marker #1', animation: google.maps.Animation.DROP, infoWindow: {content: '<strong>Marker #1</strong>'}},
			{lat: 37.76, lng: -122.46, title: 'Marker #2', animation: google.maps.Animation.DROP, infoWindow: {content: '<strong>Marker #2</strong>'}},
			{lat: 37.72, lng: -122.41, title: 'Marker #3', animation: google.maps.Animation.DROP, infoWindow: {content: '<strong>Marker #3</strong>'}},
			{lat: 37.78, lng: -122.39, title: 'Marker #4', animation: google.maps.Animation.DROP, infoWindow: {content: '<strong>Marker #4</strong>'}},
			{lat: 37.74, lng: -122.46, title: 'Marker #5', animation: google.maps.Animation.DROP, infoWindow: {content: '<strong>Marker #5</strong>'}}
		]);
	};

	// Init Street Map
	var initMapStreet = function() {
		new GMaps.createPanorama({
			el: '#js-map-street',
			lat: 37.809345,
			lng: -122.475825,
			pov: {heading: 340.91, pitch: 4},
			scrollwheel: false
		});
	};

	return {
		init: function () {
			// Gmaps.js: https://hpneo.github.io/gmaps/

			// Init Map with Search functionality
			initMapSearch();

			// Init Example Maps
			initMapGeo();
			initMapTerrain();
			initMapSatellite();
			initMapMarkers();
			initMapOverlay();
			initMapStreet();
		}
	};
}();

// Initialize when page loads
jQuery( function() {
	BaseJsMaps.init();
});
