/*
Document: base_js_charts_sparkline.js
Author: Rustheme
Description: Custom JS code used in Charts Sparkline Page
*/

var BaseJsCharts = function() {
	// jQuery Sparkline Charts: http://omnipotent.net/jquery.sparkline/#s-docs
	var initChartsSparkline = function() {
		// Bar Charts
		var $barOptions = {
			type: 'bar',
			barWidth: 8,
			barSpacing: 6,
			height: '70px',
			barColor: App.colors.green,
			tooltipPrefix: '',
			tooltipSuffix: ' Revenue',
			tooltipFormat: '{{prefix}}{{value}}{{suffix}}'
		};
		jQuery( '.js-slc-bar1' ).sparkline( 'html', $barOptions );

		$barOptions['barColor'] = App.colors.cyan;
		$barOptions['tooltipPrefix'] = '$ ';
		$barOptions['tooltipSuffix'] = '';
		jQuery( '.js-slc-bar2' ).sparkline( 'html', $barOptions );

		$barOptions['barColor'] = App.colors.blue;
		$barOptions['tooltipPrefix'] = '';
		$barOptions['tooltipSuffix'] = ' Users';
		jQuery( '.js-slc-bar3' ).sparkline( 'html', $barOptions );

		$barOptions['barColor'] = App.colors.purple;
		$barOptions['tooltipPrefix'] = '';
		$barOptions['tooltipSuffix'] = ' Companies';
		jQuery( '.js-slc-bar4' ).sparkline( 'html', $barOptions );

		// Line Charts
		var $lineOptions = {
			type: 'line',
			width: '120px',
			height: '70px',
			tooltipOffsetX: -25,
			tooltipOffsetY: 20,
			lineColor: App.colors.green,
			fillColor: App.colors.green,
			spotColor: App.colors.text_muted,
			minSpotColor: App.colors.text_muted,
			maxSpotColor: App.colors.text_muted,
			highlightSpotColor: App.colors.text_muted,
			highlightLineColor: App.colors.text_muted,
			spotRadius: 2,
			tooltipPrefix: '',
			tooltipSuffix: ' Revenue',
			tooltipFormat: '{{prefix}}{{y}}{{suffix}}'
		};
		jQuery( '.js-slc-line1' ).sparkline( 'html', $lineOptions );

		$lineOptions['lineColor'] = App.colors.blue;
		$lineOptions['fillColor'] = App.colors.blue;
		$lineOptions['tooltipPrefix'] = '$ ';
		$lineOptions['tooltipSuffix'] = '';
		jQuery( '.js-slc-line2' ).sparkline( 'html', $lineOptions );

		$lineOptions['lineColor'] = App.colors.purple;
		$lineOptions['fillColor'] = App.colors.purple;
		$lineOptions['tooltipPrefix'] = '';
		$lineOptions['tooltipSuffix'] = ' Users';
		jQuery( '.js-slc-line3' ).sparkline( 'html', $lineOptions );

		$lineOptions['lineColor'] = App.colors.cyan;
		$lineOptions['fillColor'] = App.colors.cyan;
		$lineOptions['tooltipPrefix'] = '';
		$lineOptions['tooltipSuffix'] = ' Companies';
		jQuery( '.js-slc-line4' ).sparkline( 'html', $lineOptions );

		// Pie Charts
		var $pieCharts = {
			type: 'pie',
			width: '60px',
			height: '60px',
			sliceColors: [App.colors.blue, App.colors.green, App.colors.cyan, App.colors.purple],
			tooltipPrefix: '',
			tooltipSuffix: ' Revenue',
			tooltipFormat: '{{prefix}}{{value}}{{suffix}}'
		};
		jQuery( '.js-slc-pie1' ).sparkline( 'html', $pieCharts );

		$pieCharts['tooltipPrefix'] = '$ ';
		$pieCharts['tooltipSuffix'] = '';
		jQuery( '.js-slc-pie2' ).sparkline( 'html', $pieCharts );

		$pieCharts['tooltipPrefix'] = '';
		$pieCharts['tooltipSuffix'] = ' Users';
		jQuery( '.js-slc-pie3' ).sparkline( 'html', $pieCharts );

		$pieCharts['tooltipPrefix'] = '';
		$pieCharts['tooltipSuffix'] = ' Companies';
		jQuery( '.js-slc-pie4' ).sparkline( 'html', $pieCharts );

		// Tristate Charts
		var $tristateOptions = {
			type: 'tristate',
			barWidth: 8,
			barSpacing: 6,
			height: '80px',
			posBarColor: App.colors.blue,
			negBarColor: App.colors.green
		};
		jQuery( '.js-slc-tristate1' ).sparkline( 'html', $tristateOptions );
		jQuery( '.js-slc-tristate2' ).sparkline( 'html', $tristateOptions );
		jQuery( '.js-slc-tristate3' ).sparkline( 'html', $tristateOptions );
		jQuery( '.js-slc-tristate4' ).sparkline( 'html', $tristateOptions );
	};

	return {
		init: function() {
			// Init charts
			initChartsSparkline();
		}
	};
}();

// Initialize when page loads
jQuery( function() {
	BaseJsCharts.init();
});
