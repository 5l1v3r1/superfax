# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

  $ ->
    $(".number input").on "focus", ->

      $(".bubble_" + $(this).attr "id").fadeIn()
      return

    $(".number input").on "focusout", ->
      $(".bubble").fadeOut()
      return


    return
