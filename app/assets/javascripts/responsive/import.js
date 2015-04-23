$(document).ready(function(){
    $("#csv_cancel").click(function(){
       $("#upload_csv_element").val('');
       $("#val").text('');
       $("#error_file").val('').hide();
    });
});

function validate_csv_file(){
    if($("#csv_upload_status").val() == "false"){
        $("#error_file").html("Your previous upload is in progress please try after sometime").show();
        return false;
    }else{
        if ($('#upload_csv_element').val() == ""){
          $("#error_file").html("Please choose a file").show();
          return false;
        }else{
          setTimeout(function(){jQuery("#upload_file").prop("disabled", true).css("cursor","not-allowed").css("opacity","0.3"),1000});
          $("#csv_upload").hide();
          $(".upload-progress").show();
          return true;
        }
   }
}