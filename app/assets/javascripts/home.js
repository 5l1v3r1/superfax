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

  $(".number #upload").on("change", function() {
    $(".instructions").hide();
    $(".status").show("slow");
    $(".form_fax").submit();
    $(".input_form").attr("disabled", "disabled");
  });

  $(".form_fax").bind("ajax:success", function() {
    $(".status").hide();
    $(".number").hide();
    $("#button_send").removeAttr("disabled");
    $("#button_send").text("Efetuar Pagamento");
  });
});
