jQuery(document).ready(function(){
   jQuery("#signin-now, #signup-now, .forgot-password,#user-sign-in, #sign_up_form").click(function(){
   jQuery(".error").each(function() {
     jQuery(this).html("");
    });
    jQuery("input").not('[type="submit"]').not('[type="hidden"]').not('[type="radio"]').each(function() {
      jQuery(this).val("");
    });
 });
  // Sign Up
  // Forgot password
  jQuery(".forgot_pwd").click(function(){
        jQuery('#forgot_pwd').attr('disabled',true).css("cursor","not-allowed");
    jQuery.post("/users/password", {user: {email: jQuery("#exampleInputPassword1").val()}}, function(data){
      if(data.header.status == "200"){
        jQuery("button[data-dismiss='modal']:visible").click();
        jQuery("#successful_msg .modal-title").text("Forgot Password");
        jQuery("#successful_msg .modal-body p").text("You will receive an email with instructions about how to reset your password in a few minutes.");
        jQuery("#successful_msg").modal();
        jQuery("#forgot-pwd-error").text("");
        jQuery('#forgot_pwd').removeAttr('disabled').css("cursor","pointer");
      }else{
        jQuery("#forgot-pwd-error").text(data.body.errors);
        jQuery("#forgot-pwd-error").show();
        jQuery('#forgot_pwd').removeAttr('disabled').css("cursor","pointer");
      }
    });
    return false
  });
   jQuery('#forgot_pwd, .signup_submit').removeAttr('disabled')
});

function render_signup_form()
{
   var url = window.location.href;
    var role="";
    if(url.indexOf("role=") >= 0){
    role = url.split("?")[1].split("=")[1];}
    jQuery.ajax({
      type: "get",
      data: {role:role},
      url: "/home/signup"
    });
 }

function render_signin_form()
{
    var url = window.location.href;
    var role="";
    if(url.indexOf("role=") >= 0){
        role = url.split("?")[1].split("=")[1];}
    jQuery.ajax({
      type: "get",
      data: {role:role},
      url: "/home/signin"
    });
 }

function render_forgot_password_form()
{
    var url = window.location.href;
    var role="";
    if(url.indexOf("role=") >= 0){
        role = url.split("?")[1].split("=")[1];}
    jQuery.ajax({
      type: "get",
      data: {role:role},
      url: "/home/forgot_password"
    });
 }

