/*
Document: base_ui_progress.js
Author: Rustheme
Description: Custom JS code used in Progress Page
 */

var BaseUIProgress = function() {
    // Randomize progress bars values
    var barsRandomize = function() {
        jQuery( '.js-bar-randomize' ).on( 'click', function() {
            jQuery( this )
                .parents( '.card' )
                .find( '.progress-bar' )
                .each( function() {
                    var $this   = jQuery( this );
                    var $random = Math.floor( ( Math.random() * 91 ) + 10 )  + '%';

                    $this.css( 'width', $random );

                    if ( ! $this.parent().hasClass( 'progress-mini' ) ) {
                        $this.html( $random );
                    }
                });
            });
    };

    return {
        init: function() {
            // Init randomize bar values
            barsRandomize();
        }
    };
}();

// Initialize when page loads
jQuery( function() {
	BaseUIProgress.init();
});
