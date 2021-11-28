/*
Document: base_js_charts_flot.js
Author: Rustheme
Description: Custom JS code used in Charts Flot Page
*/

var BaseJsCharts = function() {

	// Flot charts: http://www.flotcharts.org/flot/examples/
	var initChartsFlot = function() {
		// Get the elements where we will attach the charts
		var $flotLines = jQuery( '.js-flot-lines' );
		var $flotStacked = jQuery( '.js-flot-stacked' );
		var $flotLive = jQuery( '.js-flot-live' );
		var $flotPie = jQuery( '.js-flot-pie' );
		var $flotBars = jQuery( '.js-flot-bars' );

		// Demo Data (Shared between Lines, Stacked and Pie charts)
		var $dataCompanies = [
			[1, 2500],
			[2, 2300],
			[3, 3200],
			[4, 2500],
			[5, 4200],
			[6, 2400],
			[7, 3900],
			[8, 2700],
			[9, 3400],
			[10, 2200],
			[11, 3800],
			[12, 2700]
		];

		var $dataRevenue = [
			[1, 100],
			[2, 800],
			[3, 1300],
			[4, 750],
			[5, 1700],
			[6, 650],
			[7, 800],
			[8, 950],
			[9, 2600],
			[10, 1600],
			[11, 750],
			[12, 700]
		];

		var $dataUsers = [
			[1, 1100],
			[2, 700],
			[3, 1300],
			[4, 900],
			[5, 1700],
			[6, 950],
			[7, 1700],
			[8, 1250],
			[9, 1800],
			[10, 1300],
			[11, 2750],
			[12, 1400]
		];

		var $dataMonths = [
			[1, 'Jan'],
			[2, 'Feb'],
			[3, 'Mar'],
			[4, 'Apr'],
			[5, 'May'],
			[6, 'Jun'],
			[7, 'Jul'],
			[8, 'Aug'],
			[9, 'Sep'],
			[10, 'Oct'],
			[11, 'Nov'],
			[12, 'Dec']
		];

		// Init Lines chart
		jQuery.plot( $flotLines, [{
			label: 'Companies',
			data: $dataCompanies,
			shadowSize: 0,
			lines: {
				show: true,
				fill: false,
				fillColor: {
					colors: [{
						opacity: 1
					}, {
						opacity: 1
					}]
				},
			},
			points: {
				show: true,
				radius: 4
			}
		}, {
			label: 'Users',
			data: $dataUsers,
			shadowSize: 0,
			lines: {
				show: true,
				fill: false,
				fillColor: {
					colors: [{
						opacity: 1
					}, {
						opacity: 1
					}]
				}
			},
			points: {
				show: true,
				radius: 4
			}
		}], {
			colors: [
				App.colors.blue,
				App.colors.green
			],
			legend: {
				show: true,
				noColumns: 2,
				position: 'nw',
				backgroundOpacity: 0
			},
			grid: {
				borderWidth: 0,
				hoverable: true,
				clickable: true
			},
			yaxis: {
				tickColor: '#fff',
				ticks: 3
			},
			xaxis: {
				ticks: $dataMonths,
				tickColor: '#f5f5f5'
			}
		});

		// Creating and attaching a tooltip to the classic chart
		var previousPoint = null,
			ttlabel = null;
		$flotLines.bind( 'plothover', function( event, pos, item ) {
			if ( item) {
				if ( previousPoint !== item.dataIndex ) {
					previousPoint = item.dataIndex;

					jQuery( '.js-flot-tooltip' ).remove();
					var x = item.datapoint[0],
						y = item.datapoint[1];

					if ( item.seriesIndex === 0 ) {
						ttlabel = '$ <strong>' + y + '</strong>';
					} else if ( item.seriesIndex === 1) {
						ttlabel = '<strong>' + y + '</strong> Users';
					} else {
						ttlabel = '<strong>' + y + '</strong> Revenue';
					}

					jQuery( '<div class="js-flot-tooltip flot-tooltip">' + ttlabel + '</div>' )
						.css({
							top: item.pageY - 45,
							left: item.pageX + 5
						}).appendTo( 'body' ).show();
				}
			} else {
				jQuery( '.js-flot-tooltip' ).remove();
				previousPoint = null;
			}
		});

		// Stacked Chart
		/////////////////

		jQuery.plot( $flotStacked, [{
			label: 'Users',
			data: $dataUsers
		}, {
			label: 'Companies',
			data: $dataCompanies
		}, {
			label: 'Revenue',
			data: $dataRevenue
		}], {
			colors: [App.colors.blue, App.colors.green, App.colors.purple],
			series: {
				stack: true,
				lines: {
					show: true,
					fill: true
				}
			},
			lines: {
				show: true,
				lineWidth: 0,
				fill: true,
				fillColor: {
					colors: [{
						opacity: .7
					}, {
						opacity: .6
					}, {
						opacity: .5
					}]
				}
			},
			legend: {
				show: true,				
				noColumns: 3,
				position: 'nw',
				sorted: true,
				backgroundOpacity: 0
			},
			grid: {
				borderWidth: 0
			},
			yaxis: {
				tickColor: '#f5f5f5',
				ticks: 3
			},
			xaxis: {
				ticks: $dataMonths,
				tickColor: 'transparent'
			}
		});

		// Live Chart
		/////////////////

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
					lineWidth: 2,
					fill: true,
					fillColor: {
						colors: [{
							opacity: .2
						}, {
							opacity: .2
						}]
					}
				},
				colors: [App.colors.blue],
				grid: {
					borderWidth: 0,
					color: '#f5f5f5',
				},
				yaxis: {
					show: true,
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

		// Bars Chart
		/////////////////

		// Bars Chart Data
		var $dataUsersBefore = [
			[1, 500],
			[4, 390],
			[7, 700],
			[10, 600],
			[13, 800],
			[16, 1050],
			[19, 1300],
			[22, 850],
			[25, 980],
			[28, 1000],
			[31, 1350],
			[34, 1200]
		];
		var $dataUsersAfter = [
			[2, 650],
			[5, 600],
			[8, 1200],
			[11, 900],
			[14, 1300],
			[17, 1150],
			[20, 1320],
			[23, 1450],
			[26, 1300],
			[29, 1120],
			[32, 1550],
			[35, 1100]
		];

		var $dataMonthsBars = [
			[2, 'Jan'],
			[5, 'Feb'],
			[8, 'Mar'],
			[11, 'Apr'],
			[14, 'May'],
			[17, 'Jun'],
			[20, 'Jul'],
			[23, 'Aug'],
			[26, 'Sep'],
			[29, 'Oct'],
			[32, 'Nov'],
			[35, 'Dec']
		];

		// Init Bars chart
		jQuery.plot( $flotBars, [{
			label: 'Users Before',
			data: $dataUsersBefore,
			bars: {
				show: true,
				lineWidth: 0,
				fillColor: {
					colors: [{
						opacity: 1
					}, {
						opacity: 1
					}]
				}
			}
		}, {
			label: 'Users After',
			data: $dataUsersAfter,
			bars: {
				show: true,
				lineWidth: 0,
				fillColor: {
					colors: [{
						opacity: 1
					}, {
						opacity: 1
					}]
				}
			}
		}], {
			colors: [App.colors.blue, App.hexToRgba( App.colors.blue, 40 ) ],
			legend: {
				show: true,
				position: 'nw',
				backgroundOpacity: 0
			},
			grid: {
				borderWidth: 0
			},
			yaxis: {
				ticks: 3,
				tickColor: '#f5f5f5'
			},
			xaxis: {
				ticks: $dataMonthsBars,
				tickColor: '#f5f5f5'
			}
		});

		// Pie Chart
		jQuery.plot( $flotPie, [{
			label: 'Users',
			data: 22
		}, {
			label: 'Revenue',
			data: 22
		}, {
			label: 'Companies',
			data: 56
		}], {
			colors: [App.colors.orange, App.colors.green, App.colors.blue],
			legend: {
				show: false
			},
			series: {
				pie: {
					show: true,
					radius: 1,
					label: {
						show: true,
						radius: 2 / 3,
						formatter: function(label, pieSeries) {
							return '<div class="flot-pie-label">' + label + '<br>' + Math.round( pieSeries.percent ) + '%</div>';
						},
						background: {
							opacity: .75,
							color: '#000000'
						}
					}
				}
			}
		});
	};

	return {
		init: function() {
			// Init charts
			initChartsFlot();
		}
	};
}();

// Initialize when page loads
jQuery( function() {
	BaseJsCharts.init();
});
