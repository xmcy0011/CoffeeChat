/*
Document: app.js
Author: Rustheme
Description: UI Framework Custom Functionality (available to all pages)
*/

var App = function() {

	/**
	 * CORE UI FUNCTIONALITY
	 * Functions which handle core UI functionality such as Bootstrap plugins and navigation
	 * They are auto initialized on every page
	 */


	// Color variables
	var colors = {
		primary: '#7dc855',
		green: '#7dc855',
		blue: '#358ed7',
		cyan: '#39add1',
		purple: '#838cc7',
		orange: '#f8e71b',
		red: '#ef3000',
		text_muted: 'rgba(0, 20, 35, .38)',
		gray_lighter: '#f5f5f5',
	};


	// Layout variables - set in uiInit()
	var $html, $body, $wrapper, $drawer, $drawerScrollArea, $header, $content, $footer, $mask, $maskVisibleClass, $disableScrollClass;


	// User Interface init
	var uiInit = function() {
		// Set layout variables
		$html = jQuery( 'html' );
		$body = jQuery( 'body' );
		$wrapper = jQuery( '.app-layout-container' );
		$drawer = jQuery( '.app-layout-drawer' );
		$drawerHeader = jQuery( '.drawer-header' );
		$drawerScrollArea = jQuery( '.app-layout-drawer-scroll' );
		$header = jQuery( '.app-layout-header' );
		$content = jQuery( '.app-layout-content' );
		$footer = jQuery( '.app-layout-footer' );
		$maskClass = 'app-ui-mask-modal';
		$mask = jQuery( '.app-ui-mask-modal' );
		$maskVisibleClass = 'app-ui-mask-visible';
		$disableScrollClass = 'app-ui-mask-disable-scroll';
		$boxedCanvasClass = 'layout-has-boxed-canvas';
		$fixedHeaderClass = 'layout-has-fixed-header';
		$drawerClass = 'layout-has-drawer';

		// Initialize Bootstrap Tooltips
		jQuery( '[data-toggle="tooltip"], .js-tooltip' ).tooltip({
			container: 'body',
			animation: false
		});

		// Initialize Bootstrap Popovers
		jQuery( '[data-toggle="popover"], .js-popover' ).popover({
			container: 'body',
			animation: true,
			trigger: 'hover'
		});

		// Initialize Bootstrap Tabs
		jQuery( '[data-toggle="tabs"] a, .js-tabs a' ).click( function(e) {
			e.preventDefault();
			jQuery( this ).tab( 'show' );
		});

		// Initialize form placeholder (for IE9)
		jQuery( '.form-control' ).placeholder();
	};


	// Layout functionality
	var uiLayout = function() {

		// Init sidebar custom scrolling
		uiHandleScroll( 'init' );

		// Call layout API on button click
		jQuery( '[data-toggle="layout"]' ).on( 'click', function() {
			var $btn = jQuery( this );
			uiLayoutApi( $btn.data( 'action' ) );
		});

		// Hide modal mask on click
		jQuery( $mask, $maskVisibleClass ).on( 'click', function() {
			$drawer.toggleClass( 'app-ui-layout-drawer-open' );
			setTimeout( function() {
				$html.toggleClass( $disableScrollClass );
				$mask.toggleClass( $maskVisibleClass );
				$drawer.toggleClass( 'app-ui-layout-drawer-visible' );
			}, 300);
		});
	};


	// Layout API
	var uiLayoutApi = function( $mode ) {
		var $windowW = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;

		// Mode selection
		switch ( $mode ) {
			case 'sidebar_toggle':
				$html.toggleClass( $disableScrollClass );
				$mask.toggleClass( $maskVisibleClass );
				$drawer.toggleClass( 'app-ui-layout-drawer-open' );
				$drawer.toggleClass( 'app-ui-layout-drawer-visible' );
				break;
			case 'toggle_canvas':
				$body.toggleClass( $boxedCanvasClass );
				break;
			case 'toggle_header':
				$body.toggleClass( $fixedHeaderClass );
				break;
			case 'toggle_drawer':
				$body.toggleClass( $drawerClass );
				break;
			default:
				return false;
		}
	};

	// Drawer Subnav
	var uiDrawerSubnav = function() {
		// Call cards API on option button click
		jQuery( '.nav-item-has-subnav > a' ).on( 'click', function() {
			$subnavToggle = jQuery( this );
			$navHasSubnav = $subnavToggle.parent();
			$subnav = $navHasSubnav.find( '.nav-subnav' );
			$subnav.slideToggle( 200, function() {
				$navHasSubnav.toggleClass( 'open' );
			});
			//return false;
		});
	};

	// Handles drawer custom scrolling functionality
	var uiHandleScroll = function( $mode ) {
		var $windowW = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;

		// Init scrolling
		if ( $mode === 'init' ) {
			// Init scrolling only if required the first time
			uiHandleScroll();

			// Handle scrolling on resize or orientation change
			var $sScrollTimeout;

			jQuery( window ).on( 'resize orientationchange', function( event ) {
				clearTimeout( $sScrollTimeout );

				$sScrollTimeout = setTimeout( function() {
					uiHandleScroll();
				}, 150 );
			});
		} else {
			// If screen width is greater than 991 pixels
			if ( $windowW > 991 ) {
				// Turn scroll lock off (slimScroll will take care of it)
				jQuery( $drawer ).scrollLock( 'off' );
				$drawerHeight = $drawer.outerHeight();

				// If sidebar scrolling does not exist init it..
				if ( $drawerScrollArea.length && ( ! $drawerScrollArea.parent( '.slimScrollDiv' ).length ) ) {
					$drawerScrollArea
						.slimScroll({
							height: $drawerHeight,
							color: App.colors.text_muted,
							size: '5px',
							opacity: .5,
							wheelStep: 15,
							distance: '2px',
							railVisible: false,
							railOpacity: 1
						})
						// Hide scroll bar on init
						.parent().find( '.slimScrollBar' ).css( 'display', 'none' );
				} else {
					// ..else resize scrolling height
					$drawerScrollArea
						.add( $drawerScrollArea.parent() )
						.css( 'height', $drawerHeight )
				}

			} else {
				// Turn scroll lock on (sidebar and side overlay)
				jQuery( $drawer ).scrollLock();

				// If sidebar scrolling exists destroy it..
				if ( $drawerScrollArea.length && $drawerScrollArea.parent( '.slimScrollDiv' ).length ) {
					$drawerScrollArea
						.slimScroll({
							destroy: true
						});
					$drawerScrollArea
						.attr( 'style', '' );
				}
			}
		}
	};


	// Cards actions functionality
	var uiCards = function() {
		// Init default icons fullscreen and content toggle buttons
		uiCardsApi( false, 'init' );

		// Call cards API on option button click
		jQuery( '[data-toggle="card-action"]' ).on( 'click', function() {
			uiCardsApi( jQuery( this ).parents( '.card' ), jQuery( this ).data( 'action' ) );
		});
	};


	// Cards API
	var uiCardsApi = function( $card, $mode ) {
		// Set default icons for fullscreen and content toggle buttons
		var $iconFullscreen = 'ion-android-expand';
		var $iconFullscreenActive = 'ion-android-contract';
		var $iconContent = 'ion-chevron-down';
		var $iconContentActive = 'ion-chevron-up';

		if ( $mode === 'init' ) {
			// Auto add the default toggle icons to fullscreen and content toggle buttons
			jQuery( '[data-toggle="card-action"][data-action="fullscreen_toggle"]' ).each( function() {
				var $this = jQuery( this );

				$this.html( '<i class="' + ( jQuery( this ).closest( '.card' ).hasClass( 'card-act-fullscreen' ) ? $iconFullscreenActive : $iconFullscreen ) + '"></i>' );
			});

			jQuery( '[data-toggle="card-action"][data-action="content_toggle"]' ).each( function() {
				var $this = jQuery( this );

				$this.html('<i class="' + ( $this.closest( '.card' ).hasClass( 'card-act-hidden' ) ? $iconContentActive : $iconContent ) + '"></i>' );
			});
		} else {
			// Get card element
			var $elCard = ( $card instanceof jQuery ) ? $card : jQuery( $card );

			// If element exists, procceed with cards functionality
			if ( $elCard.length ) {
				// Get card action buttons if exist (need them to update their icons)
				var $btnFullscreen = jQuery( '[data-toggle="card-action"][data-action="fullscreen_toggle"]', $elCard );
				var $btnToggle = jQuery( '[data-toggle="card-action"][data-action="content_toggle"]', $elCard );

				// Mode selection
				switch ( $mode ) {
					case 'fullscreen_toggle':
						$elCard.toggleClass( 'card-act-fullscreen' );

						// Enable/disable scroll lock to card
						$elCard.hasClass( 'card-act-fullscreen' ) ? jQuery( $elCard ).scrollLock() : jQuery( $elCard ).scrollLock( 'off' );

						// Update card action icon
						if ( $btnFullscreen.length ) {
							if ( $elCard.hasClass( 'card-act-fullscreen' ) ) {
								jQuery( 'i', $btnFullscreen )
									.removeClass( $iconFullscreen )
									.addClass( $iconFullscreenActive );
							} else {
								jQuery( 'i', $btnFullscreen)
									.removeClass( $iconFullscreenActive )
									.addClass( $iconFullscreen );
							}
						}
						break;
					case 'fullscreen_on':
						$elCard.addClass( 'card-act-fullscreen' );

						// Enable scroll lock to card
						jQuery( $elCard ).scrollLock();

						// Update card action icon
						if ( $btnFullscreen.length ) {
							jQuery( 'i', $btnFullscreen )
								.removeClass( $iconFullscreen )
								.addClass( $iconFullscreenActive );
						}
						break;
					case 'fullscreen_off':
						$elCard.removeClass( 'card-act-fullscreen' );

						// Disable scroll lock to card
						jQuery( $elCard ).scrollLock( 'off' );

						// Update card action icon
						if ( $btnFullscreen.length ) {
							jQuery( 'i', $btnFullscreen )
								.removeClass( $iconFullscreenActive )
								.addClass( $iconFullscreen );
						}
						break;
					case 'content_toggle':
						$elCard.toggleClass( 'card-act-hidden' );

						// Update card action icon
						if ( $btnToggle.length ) {
							if ( $elCard.hasClass( 'card-act-hidden' ) ) {
								jQuery( 'i', $btnToggle )
									.removeClass( $iconContent )
									.addClass( $iconContentActive );
							} else {
								jQuery( 'i', $btnToggle )
									.removeClass( $iconContentActive )
									.addClass( $iconContent );
							}
						}
						break;
					case 'content_hide':
						$elCard.addClass( 'card-act-hidden' );

						// Update card action icon
						if ( $btnToggle.length ) {
							jQuery( 'i', $btnToggle )
								.removeClass( $iconContent )
								.addClass( $iconContentActive );
						}
						break;
					case 'content_show':
						$elCard.removeClass( 'card-act-hidden' );

						// Update card action icon
						if ( $btnToggle.length ) {
							jQuery( 'i', $btnToggle )
								.removeClass( $iconContentActive )
								.addClass( $iconContent );
						}
						break;
					case 'refresh_toggle':
						$elCard.toggleClass( 'card-act-refresh' );

						// Return card to normal state if the demonstration mode is on in the refresh option button - data-action-mode="demo"
						if ( jQuery( '[data-toggle="card-action"][data-action="refresh_toggle"][data-action-mode="demo"]', $elCard ).length ) {
							setTimeout( function() {
								$elCard.removeClass( 'card-act-refresh' );
							}, 2000);
						}
						break;
					case 'state_loading':
						$elCard.addClass( 'card-act-refresh' );
						break;
					case 'state_normal':
						$elCard.removeClass( 'card-act-refresh' );
						break;
					case 'close':
						$elCard.hide();
						break;
					case 'open':
						$elCard.show();
						break;
					default:
						return false;
				}
			}
		}
	};


	// Material inputs helper
	var uiForms = function() {
		jQuery( '.form-material.floating > .form-control' ).each( function() {
			var $input = jQuery( this );
			var $parent = $input.parent( '.form-material' );

			if ( $input.val() ) {
				$parent.addClass( 'open' );
			}

			$input.on( 'change', function() {
				if ( $input.val() ) {
					$parent.addClass( 'open' );
				} else {
					$parent.removeClass( 'open' );
				}
			});
		});
	};


	// Toggle class helper
	var uiToggleClass = function() {
		jQuery( '[data-toggle="class-toggle"]' ).on( 'click', function() {
			var $el = jQuery( this );

			jQuery( $el.data( 'target' ).toString() ).toggleClass( $el.data( 'class' ).toString() );

			if ( $html.hasClass( 'no-focus' ) ) {
				$el.blur();
			}
		});
	};


	// Add the correct copyright year
	var uiYearCopy = function() {
		var $date = new Date();
		var $yearCopy = jQuery( '.js-year-copy' );
		$yearCopy.html( $date.getFullYear().toString() );
	};


	/**
	 * UI HELPERS
	 * Third party plugin inits or various custom user interface helpers to extend functionality
	 * They need to be called in a page to be initialized. They are included here to be easy to
	 * init them on demand on multiple pages (usually repeated init code in common components)
	 */


	/**
	 * Print Page functionality
	 * App.initHelper( 'print-page' );
	 */
	var uiHelperPrint = function() {
		// Store all .app-layout-container classes
		var $pageCls = $wrapper.prop( 'class' );

		// Remove all classes from .app-layout-container
		$wrapper.prop( 'class', '' );

		// Print the page
		window.print();

		// Restore all .app-layout-container classes
		$wrapper.prop( 'class', $pageCls );
	};


	/**
	 * Custom Table functionality such as section toggling or checkable rows
	 * App.initHelper( 'table-tools' );
	 */

	// Table sections functionality
	var uiHelperTableToolsSections = function() {
		var $table = jQuery( '.js-table-sections' );
		var $tableRows = jQuery( '.js-table-sections-header > tr', $table );

		// When a row is clicked in tbody.js-table-sections-header
		$tableRows.click( function(e) {
			var $row = jQuery( this );
			var $tbody = $row.parent( 'tbody' );

			if ( !$tbody.hasClass( 'open')) {
				jQuery( 'tbody', $table).removeClass( 'open' );
			}

			$tbody.toggleClass( 'open' );
		});
	};

	// Checkable table functionality
	var uiHelperTableToolsCheckable = function() {
		var $table = jQuery( '.js-table-checkable' );

		// When a checkbox is clicked in thead
		jQuery( 'thead input:checkbox', $table ).click( function() {
			var $checkedStatus = jQuery( this ).prop( 'checked' );

			// Check or uncheck all checkboxes in tbody
			jQuery( 'tbody input:checkbox', $table ).each( function() {
				var $checkbox = jQuery( this );

				$checkbox.prop( 'checked', $checkedStatus );
				uiHelperTableToolscheckRow( $checkbox, $checkedStatus );
			});
		});

		// When a checkbox is clicked in tbody
		jQuery( 'tbody input:checkbox', $table ).click( function() {
			var $checkbox = jQuery( this );

			uiHelperTableToolscheckRow( $checkbox, $checkbox.prop( 'checked' ) );
		});

		// When a row is clicked in tbody
		jQuery( 'tbody > tr', $table ).click( function(e) {
			if ( e.target.type !== 'checkbox' && e.target.type !== 'button' && e.target.tagName.toLowerCase() !== 'a' && !jQuery( e.target ).parent( 'label' ).length ) {
				var $checkbox = jQuery( 'input:checkbox', this );
				var $checkedStatus = $checkbox.prop( 'checked' );

				$checkbox.prop( 'checked', !$checkedStatus );
				uiHelperTableToolscheckRow( $checkbox, !$checkedStatus );
			}
		});
	};

	// Checkable table functionality helper - Checks or unchecks table row
	var uiHelperTableToolscheckRow = function( $checkbox, $checkedStatus ) {
		if ( $checkedStatus ) {
			$checkbox
				.closest( 'tr' )
				.addClass( 'active' );
		} else {
			$checkbox
				.closest( 'tr' )
				.removeClass( 'active' );
		}
	};


	/**
	 * ALL THE FOLLOWING HELPERS REQUIRE EACH PLUGIN'S RESOURCES (JS, CSS) TO BE INCLUDED IN ORDER TO WORK
	 */


	/**
	 * Magnific Popup functionality: http://dimsemenov.com/plugins/magnific-popup/
	 * App.initHelper( 'magnific-popup' );
	 */
	var uiHelperMagnific = function() {
		// Simple Gallery init
		jQuery( '.js-gallery' ).each( function() {
			jQuery( this ).magnificPopup({
				delegate: 'a.img-link',
				type: 'image',
				gallery: {
					enabled: true
				}
			});
		});

		// Advanced Gallery init
		jQuery( '.js-gallery-advanced' ).each( function() {
			jQuery( this ).magnificPopup({
				delegate: 'a.img-lightbox',
				type: 'image',
				gallery: {
					enabled: true
				}
			});
		});
	};


	/**
	 * Slick init: http://kenwheeler.github.io/slick/
	 * App.initHelper( 'slick' );
	 */
	var uiHelperSlick = function() {
		// Get each slider element (with .js-slider class)
		jQuery( '.js-slider' ).each( function() {
			var $slider = jQuery( this );

			// Get each slider's init data
			var $sliderArrows = $slider.data( 'slider-arrows' ) ? $slider.data( 'slider-arrows' ) : false;
			var $sliderDots = $slider.data( 'slider-dots' ) ? $slider.data( 'slider-dots' ) : false;
			var $sliderNum = $slider.data( 'slider-num' ) ? $slider.data( 'slider-num' ) : 1;
			var $sliderAuto = $slider.data( 'slider-autoplay' ) ? $slider.data( 'slider-autoplay' ) : false;
			var $sliderAutoSpeed = $slider.data( 'slider-autoplay-speed' ) ? $slider.data( 'slider-autoplay-speed' ) : 3000;

			// Init slick slider
			$slider.slick({
				arrows: $sliderArrows,
				dots: $sliderDots,
				slidesToShow: $sliderNum,
				autoplay: $sliderAuto,
				autoplaySpeed: $sliderAutoSpeed
			});
		});
	};


	/**
	 * Bootstrap Datepicker init: https://github.com/eternicode/bootstrap-datepicker
	 * App.initHelper( 'datepicker' );
	 */
	var uiHelperDatepicker = function() {
		// Init datepicker (with .js-datepicker and .input-daterange class)
		jQuery( '.js-datepicker' ).add( '.input-daterange' ).datepicker({
			weekStart: 1,
			autoclose: true,
			todayHighlight: true
		});
	};


	/**
	 * Bootstrap Colorpicker init: http://mjolnic.com/bootstrap-colorpicker/
	 * App.initHelper( 'colorpicker' );
	 */
	var uiHelperColorpicker = function() {
		// Get each colorpicker element (with .js-colorpicker class)
		jQuery( '.js-colorpicker' ).each( function() {
			var $colorpicker = jQuery( this );

			// Get each colorpicker's init data
			var $colorpickerMode = $colorpicker.data( 'colorpicker-mode' ) ? $colorpicker.data( 'colorpicker-mode' ) : 'hex';
			var $colorpickerinline = $colorpicker.data( 'colorpicker-inline' ) ? true : false;

			// Init colorpicker
			$colorpicker.colorpicker({
				'format': $colorpickerMode,
				'inline': $colorpickerinline
			});
		});
	};


	/**
	 * Masked Inputs: http://digitalbush.com/projects/masked-input-plugin/
	 * App.initHelper( 'masked-inputs' );
	 */
	var uiHelperMaskedInputs = function() {
		// Init Masked Inputs
		// a - Represents an alpha character (A-Z,a-z)
		// 9 - Represents a numeric character (0-9)
		// * - Represents an alphanumeric character (A-Z,a-z,0-9)
		jQuery( '.js-masked-date' ).mask( '99/99/9999' );
		jQuery( '.js-masked-date-dash' ).mask( '99-99-9999' );
		jQuery( '.js-masked-phone' ).mask( '(999) 999-9999' );
		jQuery( '.js-masked-phone-ext' ).mask( '(999) 999-9999? x99999' );
		jQuery( '.js-masked-taxid' ).mask( '99-9999999' );
		jQuery( '.js-masked-ssn' ).mask( '999-99-9999' );
		jQuery( '.js-masked-pkey' ).mask( 'a*-999-a999' );
	};


	/**
	 * Tags Inputs: https://github.com/xoxco/jQuery-Tags-Input
	 * App.initHelper( 'tags-inputs' );
	 */
	var uiHelperTagsInputs = function() {
		// Init Tags Inputs (with .js-tags-input class)
		jQuery( '.js-tags-input' ).tagsInput({
			height: '36px',
			width: '100%',
			defaultText: 'Add tag',
			removeWithBackspace: true,
			delimiter: [',']
		});
	};


	/**
	 * Select2: https://github.com/select2/select2
	 * App.initHelper( 'select2' );
	 */
	var uiHelperSelect2 = function() {
		// Init Select2 (with .js-select2 class)
		jQuery( '.js-select2' ).select2();
	};


	/**
	 * Highlight.js: https://highlightjs.org/usage/
	 * App.initHelper( 'highlightjs' );
	 */
	var uiHelperHighlightjs = function() {
		// Init Highlight.js
		hljs.initHighlightingOnLoad();
	};


	/**
	 * Bootstrap Notify: http://bootstrap-growl.remabledesigns.com/
	 * App.initHelper( 'notify' );
	 */
	var uiHelperNotify = function() {
		// Init notifications (with .js-notify class)
		jQuery( '.js-notify' ).on( 'click', function() {
			var $notify = jQuery( this );
			var $notifyMsg = $notify.data( 'notify-message' );
			var $notifyType = $notify.data( 'notify-type' ) ? $notify.data( 'notify-type' ) : 'info';
			var $notifyFrom = $notify.data( 'notify-from' ) ? $notify.data( 'notify-from' ) : 'top';
			var $notifyAlign = $notify.data( 'notify-align' ) ? $notify.data( 'notify-align' ) : 'right';
			var $notifyIcon = $notify.data( 'notify-icon' ) ? $notify.data( 'notify-icon' ) : '';
			var $notifyUrl = $notify.data( 'notify-url' ) ? $notify.data( 'notify-url' ) : '';

			jQuery.notify({
				icon: $notifyIcon,
				message: $notifyMsg,
				url: $notifyUrl
			}, {
				element: 'body',
				type: $notifyType,
				allow_dismiss: true,
				newest_on_top: true,
				showProgressbar: false,
				placement: {
					from: $notifyFrom,
					align: $notifyAlign
				},
				offset: 20,
				spacing: 10,
				z_index: 1031,
				delay: 5000,
				timer: 1000,
				animate: {
					enter: 'animated fadeIn',
					exit: 'animated fadeOutDown'
				}
			});
		});
	};


	/**
	 * Draggable items with jQuery: https://jqueryui.com/sortable/
	 * App.initHelper( 'draggable-items' );
	 */
	var uiHelperDraggableItems = function() {
		// Init draggable items functionality (with .js-draggable-items class)
		jQuery( '.js-draggable-items' ).sortable({
			connectWith: '.draggable-column',
			items: '.draggable-item',
			opacity: .75,
			handle: '.draggable-handler',
			placeholder: 'draggable-placeholder',
			tolerance: 'pointer',
			start: function( e, ui ) {
				ui.placeholder.css({
					'height': ui.item.outerHeight(),
					'margin-bottom': ui.item.css( 'margin-bottom' )
				});
			}
		});
	};

	return {
		init: function() {
			// Init all core functions
			uiInit();
			uiLayout();
			uiDrawerSubnav();
			uiCards();
			uiForms();
			uiToggleClass();
			uiYearCopy();
		},
		layout: function( $mode ) {
			uiLayoutApi( $mode );
		},
		cards: function( $card, $mode ) {
			uiCardsApi( $card, $mode );
		},
		initHelper: function( $helper ) {
			switch ( $helper ) {
				case 'print-page':
					uiHelperPrint();
					break;
				case 'table-tools':
					uiHelperTableToolsSections();
					uiHelperTableToolsCheckable();
					break;
				case 'magnific-popup':
					uiHelperMagnific();
					break;
				case 'slick':
					uiHelperSlick();
					break;
				case 'datepicker':
					uiHelperDatepicker();
					break;
				case 'colorpicker':
					uiHelperColorpicker();
					break;
				case 'tags-inputs':
					uiHelperTagsInputs();
					break;
				case 'masked-inputs':
					uiHelperMaskedInputs();
					break;
				case 'select2':
					uiHelperSelect2();
					break;
				case 'highlightjs':
					uiHelperHighlightjs();
					break;
				case 'notify':
					uiHelperNotify();
					break;
				case 'draggable-items':
					uiHelperDraggableItems();
					break;
				default:
					return false;
			}
		},
		initHelpers: function( $helpers ) {
			if ( $helpers instanceof Array ) {
				for ( var $index in $helpers ) {
					App.initHelper( $helpers[$index] );
				}
			} else {
				App.initHelper( $helpers );
			}
		},
		// Convert hex to rgba function
		hexToRgba: function( hex, opacity ) {
			hex = hex.replace( '#', '' );
			r = parseInt( hex.substring( 0, 2 ), 16 );
			g = parseInt( hex.substring( 2, 4 ), 16 );
			b = parseInt( hex.substring( 4, 6 ), 16 );
			result = 'rgba( ' + r + ', ' + g + ', ' + b + ', ' + opacity / 100 + ')';
			return result;
		},
		colors: colors,
	};
}();

// Initialize app when page loads
jQuery( function() {
	App.init();
});
