$(function() {
  $(".number input").on("focus", function() {
    $(".bubble_" + $(this).attr("id")).fadeIn();
  });

  $(".number input").on("focusout", function() {
    $(".bubble").fadeOut();
  });

  $(".number #button_send").on("click", function(e) {
    e.preventDefault();
    $(".alert-danger").hide();
    $(".main_panel").css("height", "350px");
    $(".bubble").css("top", "100px");
    verify_fields(function() {
      $(".number #upload").get(0).click();
    });
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
  });

  $("#send_fax").on("click", function(e) {
    e.preventDefault();
    var fax_id = $(this).attr("fax_id");
    $.ajax({
      type: "POST",
      url: "/send_fax",
      data: {fax_id: fax_id},
    });
  });
  
  $("#payment").on("click", function() {
    $("#form_payment").submit();
  });
});

function verify_fields(callback) {
  var message = "";
  if($("#country_code").val() == "") {
    message = "Selecione o código do país para o qual deseja enviar.<br>";
  }
  if($("#ddd").val() == "") {
    message += "Digite o ddd do número para o qual deseja enviar o fax.<br>";
  }
  if($("#number").val() == "") {
    message += "O campo número não pode ficar em branco.";
  }

  if(message != "") {
    $(".alert-danger").html(message);
    $(".alert-danger").show();
    $(".main_panel").css("height", "420px");
    $(".bubble").css("top", "180px");
  }
  else {
    callback();
  }
}

function fax_sended(data) {
  alert(JSON.stringify(data));
}

function fax_sended_error(data) {
  alert("erro\n " + JSON.stringify(data));
}
