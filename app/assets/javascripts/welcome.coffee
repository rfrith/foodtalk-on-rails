# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Hide Header on on scroll down

$(document).on "turbolinks:load", ->
  return unless $(".welcome.index").length > 0
  $(document).ready ->
# hide .navbar first
    $('#footer-nav').hide()

    # fade in .navbar
    $ ->
      $(window).scroll ->
# set distance user needs to scroll before we fadeIn navbar
        if $(this).scrollTop() > 5
          $('#footer-nav').show()
#else if $(this).scrollTop() > 1
#$('#nav-top').show()
        else
          $('#footer-nav').hide()
        #$('#nav-top').hide()
        return
      return
    return
  return