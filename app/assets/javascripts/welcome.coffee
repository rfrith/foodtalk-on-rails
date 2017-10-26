# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Hide Header on on scroll down
$(document).on "turbolinks:load", ->
  #hide footer on index page, otherwise show it
  if ($(".welcome.index").length > 0)
    $('#footer-nav').hide()
  else
    $('#footer-nav').show()
  #show/hide footer based on scroll distance
  $(window).scroll ->
    if ($(".welcome.index").length > 0)
    # set distance user needs to scroll before we fadeIn navbar
      if $(this).scrollTop() > 5
        $('#footer-nav').show()
      else
        $('#footer-nav').hide()
    else
      $('#footer-nav').show()
return