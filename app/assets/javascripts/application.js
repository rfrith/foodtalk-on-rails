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
//= require chartkick

//= require_tree .

$(document).on("turbolinks:load", function() {

    //initialize plugins

    $('[data-toggle="popover"]').popover();

    $('.popover-dismiss').popover({
        trigger: 'focus'
    })

    if( $('.grid').length) {
        $('.grid').imagesLoaded( function() {
            $('.grid').masonry({
                // options
                itemSelector: '.grid-item',
                fitWidth: true
            });
        });
    }

    if($("#dashboard-content").length) {
        init_isotope_started_courses();
    }

    $('#wp-search').submit(function () {
        $.fancybox.open({
            src  : '//blog.foodtalk.org/?'+ $(this).serialize(),
            type : 'iframe'
        });
        return false;
    });
});

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

function launchVideo(videoPath, surveyPath) {
    $.fancybox.open({
        src  : videoPath,
        type : 'iframe',
        opts : {
            afterClose : function( instance, current ) {
                if(surveyPath != 'undefined') {
                    parent.location.href = surveyPath;
                }
            }
        }
    });
    return false; //cancel click event
}