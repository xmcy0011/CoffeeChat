/*
Document: base_js_charts_chartjs.js
Author: Rustheme
Description: Custom JS code used in Charts Chart.js Page
*/

var BaseJsCharts = function() {
	// Chart.js Charts: http://www.chartjs.org/docs
	var initChartsChartJS = function() {

		// Get Chart Containers
		var $chartLinesCnt = jQuery( '.js-chartjs-lines' )[0].getContext( '2d' ),
			$chartBarsCnt = jQuery( '.js-chartjs-bars' )[0].getContext( '2d' ),
			$chartRadarCnt = jQuery( '.js-chartjs-radar' )[0].getContext( '2d' ),
			$chartPolarCnt = jQuery( '.js-chartjs-polar' )[0].getContext( '2d' ),
			$chartPieCnt = jQuery( '.js-chartjs-pie' )[0].getContext( '2d' ),
			$chartDonutCnt = jQuery( '.js-chartjs-donut' )[0].getContext( '2d' );

		// Set global chart options
		var $globalOptions = {
			scaleFontFamily: 'Roboto, Arial, sans-serif',
			scaleFontColor: App.colors.text_muted,
			scaleFontStyle: '500',
			tooltipTitleFontFamily: 'Roboto, Arial, sans-serif',
			tooltipCornerRadius: 2,
			maintainAspectRatio: false,
			responsive: true,
			animation: false,
		};

		// Lines/Bar/Radar Chart Data
		var $chartLinesBarsRadarData = {
			labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
			datasets: [{
				label: 'Last Week',
				fillColor: App.hexToRgba( App.colors.blue, 20 ),
				strokeColor: App.hexToRgba( App.colors.blue, 40 ),
				pointColor: App.hexToRgba( App.colors.blue, 40 ),
				pointStrokeColor: '#fff',
				data: [30, 32, 40, 45, 43, 38, 55]
			}, {
				label: 'This Week',
				fillColor: App.hexToRgba( App.colors.blue, 70 ),
				strokeColor: App.colors.blue,
				pointColor: App.colors.blue,
				pointStrokeColor: '#fff',
				data: [15, 16, 20, 25, 23, 25, 32]
			}]
		};

		// Polar/Pie/Donut Data
		var $chartPolarPieDonutData = [{
			value: 56,
			color: App.colors.green,
			highlight: App.hexToRgba( App.colors.green, 70 ),
			label: 'Companies'
		}, {
			value: 22,
			color: App.colors.orange,
			highlight: App.hexToRgba( App.colors.orange, 50 ),
			label: 'Users'
		}, {
			value: 22,
			color: App.colors.blue,
			highlight: App.hexToRgba( App.colors.blue, 70 ),
			label: 'Revenue'
		}];

		// Init Charts
		$chartLines = new Chart( $chartLinesCnt ).Line( $chartLinesBarsRadarData, $globalOptions );
		$chartBars = new Chart( $chartBarsCnt ).Bar( $chartLinesBarsRadarData, $globalOptions );
		$chartRadar = new Chart( $chartRadarCnt ).Radar( $chartLinesBarsRadarData, $globalOptions );
		$chartPolar = new Chart( $chartPolarCnt ).PolarArea( $chartPolarPieDonutData, $globalOptions );
		$chartPie = new Chart( $chartPieCnt ).Pie( $chartPolarPieDonutData, $globalOptions );
		$chartDonut = new Chart( $chartDonutCnt ).Doughnut( $chartPolarPieDonutData, $globalOptions );
	};

	return {
		init: function() {
			// Init charts
			initChartsChartJS();
		}
	};
}();

// Initialize when page loads
jQuery( function() {
	BaseJsCharts.init();
});
