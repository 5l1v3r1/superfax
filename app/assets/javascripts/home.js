$(function() {
  $(".number input").on("focus", function() {
    $(".bubble_" + $(this).attr("id")).fadeIn();
  });

  $(".number input").on("focusout", function() {
    $(".bubble").fadeOut();
  });

  $(".number #button_send").on("click", function(e) {
    e.preventDefault();
    $(".number #upload").get(0).click();
  });
});
