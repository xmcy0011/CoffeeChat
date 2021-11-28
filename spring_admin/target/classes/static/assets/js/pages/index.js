/*
Document: base_pages_dashboard.js
Author: Rustheme
Description: Custom JS code used in Dashboard Page (index.html)
 */

var BasePagesDashboard = function() {
	// Chart.js Chart: http://www.chartjs.org/docs
	var initDashChartJS = function() {

		// Get Chart Containers
		var $dashChartLinesCnt1 = jQuery( '.js-chartjs-lines1' )[0].getContext( '2d' ),
			$dashChartLinesCnt2 = jQuery( '.js-chartjs-lines2' )[0].getContext( '2d' ),
			$dashChartBarsCnt = jQuery( '.js-chartjs-bars' )[0].getContext( '2d' ),
			$dashChartLinesCnt3 = jQuery( '.js-chartjs-lines3' )[0].getContext( '2d' ),
			$dashChartLinesCnt4 = jQuery( '.js-chartjs-lines4' )[0].getContext( '2d' ),
			$dashChartLinesCnt5 = jQuery( '.js-chartjs-lines5' )[0].getContext( '2d' ),
			$dashChartLinesCnt6 = jQuery( '.js-chartjs-lines6' )[0].getContext( '2d' ),
			$flotLive = jQuery( '.js-flot-live' );

		// Set global chart options
		var $globalOptions = {
			showScale: false,
			tooltipCornerRadius: 2,
			maintainAspectRatio: false,
			responsive: true,
			animation: false,
			pointDotStrokeWidth: 2,
		};

		// Lines Chart Data 1
		var $dashChartLinesData = {
			labels: ['2003', '2004', '2005', '2006', '2007', '2008', '2009', '2010', '2011', '2012', '2013', '2014'],
			datasets: [
				{
					label: 'This Week',
					fillColor: 'rgba(255, 255, 255, .1)',
					strokeColor: 'rgba(255, 255, 255, .38)',
					pointColor: App.colors.blue,
					pointStrokeColor: '#fff',
					data: [20, 40, 24, 75, 16, 42, 20, 42, 40, 65, 48, 56, 80, 95]
				}
			]
		};

		// Lines Chart Data 2
		var $dashChartLinesData2 = {
			labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
			datasets: [
				{
					label: 'This Week',
					fillColor: App.hexToRgba( App.colors.blue, 20 ),
					strokeColor: App.hexToRgba( App.colors.blue, 20 ),
					pointColor: '#fff',
					pointStrokeColor: App.hexToRgba( App.colors.blue, 70 ),
					data: [20, 25, 40, 30, 55, 60, 80]
				}
			]
		};

		// Lines Chart Data 3
		var $dashChartLinesData3 = {
			labels: ['20', '40', '60', '80', '100', '120', '140'],
			datasets: [
				{
					label: 'This Week',
					fillColor: App.hexToRgba( App.colors.blue, 50 ),
					pointColor: App.colors.blue,
					data: [2500, 1500, 1200, 3200, 4800, 3500, 1500]
				}
			]
		};

		// Lines Chart Data 4
		var $dashChartLinesData4 = {
			labels: ['2003', '2004', '2005', '2006', '2007', '2008', '2009', '2010', '2011', '2012', '2013', '2014'],
			datasets: [
				{
					label: 'This Week',
					strokeColor: App.colors.blue,
					pointColor: '#fff',
					pointStrokeColor: App.colors.blue,
					data: [20, 25, 40, 30, 45, 40, 55, 40, 48, 40, 42, 50]
				}
			]
		};

		// Lines Chart Data 5
		var $dashChartLinesData5 = {
			labels: ['2003', '2004', '2005', '2006', '2007', '2008', '2009', '2010', '2011', '2012', '2013', '2014'],
			datasets: [
				{
					label: 'This Week',
					fillColor: App.hexToRgba( App.colors.green, 30 ),
					strokeColor: App.colors.green,
					pointColor: '#fff',
					pointStrokeColor: App.colors.green,
					data: [20, 25, 40, 30, 45, 40, 55, 40, 48, 40, 42, 50]
				}
			]
		};

		// Lines Chart Data 6
		var $dashChartLinesData6 = {
			labels: ['2005', '2006', '2007', '2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016'],
			datasets: [
				{
					label: 'This Week',
					fillColor: App.hexToRgba( App.colors.purple, 30 ),
					strokeColor: App.colors.purple,
					pointColor: '#fff',
					pointStrokeColor: App.colors.purple,
					data: [55, 40, 48, 40, 42, 50, 20, 25, 40, 30, 45, 40]
				}
			]
		};

		// Lines Chart Data 7
		var $dashChartLinesData7 = {
			labels: ['2007', '2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016'],
			datasets: [
				{
					fillColor: App.hexToRgba( App.colors.green, 30 ),
					strokeColor: App.colors.green,
					pointColor: '#fff',
					pointDot: false,
					pointStrokeColor: App.colors.green,
					data: [50, 45, 52, 35, 45, 64, 50, 47, 45, 53]
				}
			]
		};

		// Lines Chart Data 8
		var $dashChartLinesData8 = {
			labels: ['2007', '2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016'],
			datasets: [
				{
					fillColor: App.hexToRgba( App.colors.blue, 30 ),
					strokeColor: App.colors.blue,
					pointColor: '#fff',
					pointDot: false,
					pointStrokeColor: App.colors.blue,
					data: [30, 35, 42, 35, 60, 38, 50, 40, 48, 48]
				}
			]
		};

		// Lines Chart Data 9
		var $dashChartLinesData9 = {
			labels: ['2007', '2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016'],
			datasets: [
				{
					fillColor: App.hexToRgba( App.colors.purple, 30 ),
					strokeColor: App.colors.purple,
					pointColor: '#fff',
					pointDot: false,
					pointStrokeColor: App.colors.purple,
					data: [60, 55, 52, 38, 62, 40, 50, 46, 50, 54]
				}
			]
		};

		// Init Lines Chart
		$dashChartLines = new Chart( $dashChartLinesCnt1 ).Line( $dashChartLinesData, $globalOptions );

		// Init Lines Chart 2
		$dashChartLines2 = new Chart( $dashChartLinesCnt2 ).Line( $dashChartLinesData2, $globalOptions );

		// Init Lines Chart Bars
		$dashChartBars = new Chart( $dashChartBarsCnt ).Bar( $dashChartLinesData3, {
			scaleBeginAtZero: false,
			scaleShowVerticalLines: false,
			barShowStroke: false,
			scaleFontFamily: "'Roboto', 'Helvetica Neue', Helvetica, Arial, sans-serif",
			scaleFontColor: App.colors.text_muted,
			tooltipTitleFontFamily: "'Roboto', 'Helvetica Neue', Helvetica, Arial, sans-serif",
			tooltipCornerRadius: 2,
			maintainAspectRatio: false,
			responsive: true,
			animation: false,
		});

		// Init Lines Chart 4
		$dashChartLines4 = new Chart( $dashChartLinesCnt3 ).Line( $dashChartLinesData4, {
			scaleShowHorizontalLines: false,
			bezierCurve: false,
			datasetFill: false,
			pointDotStrokeWidth: 2,
			scaleFontFamily: "'Roboto', 'Helvetica Neue', Helvetica, Arial, sans-serif",
			scaleFontColor: App.colors.text_muted,
			scaleFontStyle: '500',
			tooltipTitleFontFamily: "'Roboto', 'Helvetica Neue', Helvetica, Arial, sans-serif",
			tooltipCornerRadius: 2,
			maintainAspectRatio: false,
			responsive: true,
			animation: false,
		});

		// "Company overview" widget
		// Init Lines Chart 4
		$dashChartLines4 = new Chart( $dashChartLinesCnt4 ).Line( $dashChartLinesData7, {
			pointDot: false,
			showScale: false,
			maintainAspectRatio: false,
			responsive: true,
			animation: false,
		});

		// Init Lines Chart 5
		$dashChartLines5 = new Chart( $dashChartLinesCnt5 ).Line( $dashChartLinesData8, {
			pointDot: false,
			showScale: false,
			maintainAspectRatio: false,
			responsive: true,
			animation: false,
		});

		// Init Lines Chart 6
		$dashChartLines6 = new Chart( $dashChartLinesCnt6 ).Line( $dashChartLinesData9, {
			pointDot: false,
			showScale: false,
			maintainAspectRatio: false,
			responsive: true,
			animation: false,
		});

		// Live Chart
		var $dataLive = [];

		// Generate random data
		function getRandomData() {

			if ( $dataLive.length > 0 )
				$dataLive = $dataLive.slice( 1 );

			while ( $dataLive.length < 300 ) {
				var prev = $dataLive.length > 0 ? $dataLive[$dataLive.length - 1] : 50;
				var y = prev + Math.random() * 10 - 5;
				if ( y < 0 )
					y = 0;
				if ( y > 100 )
					y = 100;
				$dataLive.push( y );
			}

			var res = [];
			for ( var i = 0; i < $dataLive.length; ++i )
				res.push([i, $dataLive[i]]);

			// Show live chart info
			jQuery( '.js-flot-live-info' ).html( y.toFixed( 0 ) + '%' );

			return res;
		}

		// Update live chart
		function updateChartLive() {
			$chartLive.setData( [getRandomData()] );
			$chartLive.draw();
			setTimeout( updateChartLive, 70 );
		}

		// Init live chart
		var $chartLive = jQuery.plot( $flotLive,
			[{
				data: getRandomData()
			}], {
				series: {
					shadowSize: 0
				},
				lines: {
					show: true,
					lineWidth: 1,
					fill: true,
					fillColor: {
						colors: [{
							opacity: .2
						}, {
							opacity: .2
						}]
					}
				},
				colors: ['#fff'],
				grid: {
					borderWidth: 0,
					color: App.colors.gray_lighter,
				},
				yaxis: {
					show: false,
					min: 0,
					max: 110
				},
				xaxis: {
					show: false
				}
			}
		);

		// Start getting new data
		updateChartLive();
	};

	return {
		init: function () {
			// Init ChartJS chart
			initDashChartJS();
		}
	};
}();

// Initialize when page loads
jQuery( function() {
	BasePagesDashboard.init();
});
