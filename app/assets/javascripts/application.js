// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require turbolinks
//= require popper
//= require bootstrap
//= require lity

//= require_tree .

$(document).on("turbolinks:load", function() {

    //initialize plugins

    $('[data-toggle="popover"]').popover();

    $('.popover-dismiss').popover({
        trigger: 'focus'
    })

    $('.grid').imagesLoaded( function() {


        $('.grid').masonry({
            // options
            itemSelector: '.grid-item',
            fitWidth: true
        });

    });

    if($("#dashboard-content").length > 0) {
        init_isotope_started_courses();

        $('a[data-toggle=tab]').on('shown.bs.tab', function (e) {
            switch(e.target.id ) {
                case 'started-courses-tab-link':
                    //alert('started-courses-tab-link');
                    init_isotope_started_courses();
                    break;
                case 'completed-courses-tab-link':
                    //alert('completed-courses-tab-link');
                    init_isotope_completed_courses();
                    break;
            }
        })
    }

});

//TODO: DRY - can this be simplified??

function init_isotope_started_courses() {

    $('.food-etalk-started-grid').imagesLoaded( function() {
        $('.food-etalk-started-grid').isotope({
            // options
            itemSelector: '.module-grid-item',
            layoutMode: 'fitRows'
        });
    });

    $('.better-u-started-grid').imagesLoaded( function() {
        $('.better-u-started-grid').isotope({
            // options
            itemSelector: '.module-grid-item',
            layoutMode: 'fitRows'
        });
    });
}

function init_isotope_completed_courses() {
    $('.food-etalk-completed-grid').imagesLoaded( function() {
        $('.food-etalk-completed-grid').isotope({
            // options
            itemSelector: '.module-grid-item',
            layoutMode: 'fitRows'
        });
    });
    $('.better-u-completed-grid').imagesLoaded( function() {
        $('.better-u-completed-grid').isotope({
            // options
            itemSelector: '.module-grid-item',
            layoutMode: 'fitRows'
        });
    });
}