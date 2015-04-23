  function add_tab_index()
  {
   // $(":input").each(function (i) { $(this).attr('tabindex', i + 1); });
  }
function enable_quill_pad()
{
  var ans_opt = [];
  for (i=0; i< jQuery("#another_answer :text").length;i++)
  {
    if (document.getElementById('single_ans_'+i).value == "")
    {
      ans_opt.push("")
    }
    else
    {
      ans_opt.push(document.getElementById('single_ans_'+i).value)
    }
  }
  delete_all_answer();
  remove_quill_pad_element();
  var increase_count = 0;
  for ( var i = 0; i < ans_opt.length; i++ ) {
    jQuery("#another_answer").append("<div class='row' id='row_count_"+increase_count+"'><div class='col-lg-10 col-md-9 col-sm-9'><div class='form-group'><label class='sr-only' for='InputAnswer"+increase_count+"'>Answer</label><input type='text' class='form-control input-medium ans_count' id='single_ans_"+increase_count+"' placeholder='Answer' name='ans["+increase_count+"]'/></div></div></div>");
    Quill.init("single_ans_"+increase_count,'langlist',null);
    Quill.loadText(ans_opt[increase_count],"single_ans_"+increase_count);
    $("#single_ans_"+increase_count).next().css('background-color','#ffffff');
    $("#single_ans_"+increase_count).next().css('background-image','none');
    $("#single_ans_"+increase_count).next().css('border','1px solid #cccccc');
    $("#single_ans_"+increase_count).next().css('border-radius','4px');
    $("#single_ans_"+increase_count).next().css('box-shadow','01px rgba(0,0,0,0.075) inset');
    $("#single_ans_"+increase_count).next().css('padding','6px 12px');
    increase_count = increase_count +1;
  }
  add_delete_button();
}

function remove_quill_pad_element()
{
    for ( var i = 0; i < 4; i++ ) {
    Quill.remove("single_ans_"+i);
  }
}
function question_body_css()
{
 $("#Quillquestion_body_container").css('background-color','#ffffff');
 $("#Quillquestion_body_container").css('background-image','none');
 $("#Quillquestion_body_container").css('border','1px solid #cccccc');
 $("#Quillquestion_body_container").css('border-radius','4px');
 $("#Quillquestion_body_container").css('box-shadow','01px rgba(0,0,0,0.075) inset');
 $("#Quillquestion_body_container").css('padding','6px 12px');
}

function tanks_response_css(){
  $("#Quillquestion_thanks_response_container").css('background-color','#ffffff');
  $("#Quillquestion_thanks_response_container").css('background-image','none');
  $("#Quillquestion_thanks_response_container").css('border','1px solid #cccccc');
  $("#Quillquestion_thanks_response_container").css('border-radius','4px');
  $("#Quillquestion_thanks_response_container").css('box-shadow','01px rgba(0,0,0,0.075) inset');
  $("#Quillquestion_thanks_response_container").css('padding','6px 12px');
}

function add_answer_text()
{
  var increase_count = jQuery(".tab-content #another_answer :text").length;
  jQuery("#another_answer").append("<div class='row' id='row_count_"+increase_count+"'><div class='col-lg-10 col-md-9 col-sm-9'><div class='form-group'><label class='sr-only' for='InputAnswer"+increase_count+"'>Answer</label><input type='text' class='form-control input-medium ans_count' id='InputAnswer"+increase_count+"' placeholder='Answer' name='ans["+increase_count+"]'/></div></div></div>");
}

function delete_all_answer()
{
  var initial_count=0;
  jQuery("#another_answer :text").each(function(){
   jQuery('#row_count_'+initial_count).remove();
   initial_count = initial_count+1;
 })
}
// question form create
function single_qst_tab_select()
{
  $('#question_type').attr('value',1);
  $("#single_qst_tab").parent().addClass("active");
  $("#multiple_qst_tab").parent().removeClass("active");
  $("#yes_no_tab").parent().removeClass("active");
  $("#comment_tab").parent().removeClass("active");
  $("#multi_tap_question").remove();
  $("#yes_no_tap_question").remove();
  $("#comment_tap_question").remove();
  enable_quill_pad();
}
function multi_sql_tab_select()
{
  $('#question_type').attr('value',2);
  $("#single_qst_tab").parent().removeClass("active");
  $("#multiple_qst_tab").parent().addClass("active");
  $("#yes_no_tab").parent().removeClass("active");
  $("#comment_tab").parent().removeClass("active");
  $("#single_tap_question").remove();
  $("#yes_no_tap_question").remove();
  $("#comment_tap_question").remove();
  enable_quill_pad();
}
function yes_no_tab_select()
{
  $('#question_type').attr('value',3);
  $("#single_qst_tab").parent().removeClass("active");
  $("#multiple_qst_tab").parent().removeClass("active");
  $("#yes_no_tab").parent().addClass("active");
  $("#comment_tab").parent().removeClass("active");
  $("#single_tap_question").remove();
  $("#multi_tap_question").remove();
  $("#comment_tap_question").remove();

}
function comment_tab_select()
{
  $('#question_type').attr('value',4);
  $("#single_qst_tab").parent().removeClass("active");
  $("#multiple_qst_tab").parent().removeClass("active");
  $("#yes_no_tab").parent().removeClass("active");
  $("#comment_tab").parent().addClass("active");
  $("#single_tap_question").remove();
  $("#multi_tap_question").remove();
  $("#yes_no_tap_question").remove();
}
function reindex(){
  re_index_count=0;
  jQuery("#another_answer :text").each(function(){
    jQuery(this).parent().parent().parent().removeAttr("id");
    jQuery(this).parent().parent().parent().attr("id","row_count_"+re_index_count);
    jQuery(this).attr("name","ans["+re_index_count+"]");
    jQuery(this).attr("id","single_ans_"+re_index_count);
    re_index_count=re_index_count+1;
  });
  add_tab_index();
}

function enable_button()
{
  reindex();
  var count = jQuery("#another_answer :text").length;
  if (count >= 4) {
    jQuery('#add_another_button').hide();
  }
  else {
    jQuery('#add_another_button').show();
  }
}
// question form create

function load_question_body_text(question)
{
  Quill.remove('question_body');
  Quill.init('question_body','langlist',null);
  Quill.loadText(question.replace(/(!-!-!-!)/gm,'\r\n'),'question_body');
}
function load_thanks_response_text(thanks_response)
{
  Quill.remove('question_thanks_response');
  Quill.init('question_thanks_response','langlist',null);
  Quill.loadText(thanks_response.replace(/(!-!-!-!)/gm,'\r\n'),'question_thanks_response');
}

function clear_answer_option()
{
  for (i=0; i< jQuery("#another_answer :text").length;i++)
  {
    Quill.clearText('single_ans_'+i)
  }
  clear_other_check_box();
}
function clear_other_check_box()
{
  jQuery("#question_include_other").attr('checked',false);
  jQuery("#question_include_text").attr('checked',false);
}
function single_qst_tab_select_edit()
{
  $('#question_type').attr('value',1);
  $("#single_qst_tab").parent().addClass("active");
  $("#multiple_qst_tab").parent().removeClass("active");
  $("#yes_no_tab").parent().removeClass("active");
  $("#comment_tab").parent().removeClass("active");
  $("#single_answer").addClass("active");
  $("#multiple_answer").removeClass("active");
  $("#yes_no").removeClass("active");
  $("#comment").removeClass("active");

  $("#multi_tap_question").remove();
  $("#yes_no_tap_question").remove();
  $("#comment_tap_question").remove();
}
function multi_sql_tab_select_edit()
{
  $('#question_type').attr('value',2);
  $("#single_qst_tab").parent().removeClass("active");
  $("#multiple_qst_tab").parent().addClass("active");
  $("#yes_no_tab").parent().removeClass("active");
  $("#comment_tab").parent().removeClass("active");
  $("#single_answer").removeClass("active");
  $("#multiple_answer").addClass("active");
  $("#yes_no").removeClass("active");
  $("#comment").removeClass("active");
  $("#single_tap_question").remove();
  $("#yes_no_tap_question").remove();
  $("#comment_tap_question").remove();
}
function yes_no_tab_select_edit()
{
  $('#question_type').attr('value',3);
  $("#single_qst_tab").parent().removeClass("active");
  $("#multiple_qst_tab").parent().removeClass("active");
  $("#yes_no_tab").parent().addClass("active");
  $("#comment_tab").parent().removeClass("active");
  $("#single_answer").removeClass("active");
  $("#multiple_answer").removeClass("active");
  $("#yes_no").addClass("active");
  $("#comment").removeClass("active");
  $("#single_tap_question").remove();
  $("#multi_tap_question").remove();
  $("#comment_tap_question").remove();
}
function comment_tab_select_edit()
{
  $('#question_type').attr('value',4);
  $("#single_qst_tab").parent().removeClass("active");
  $("#multiple_qst_tab").parent().removeClass("active");
  $("#yes_no_tab").parent().removeClass("active");
  $("#comment_tab").parent().addClass("active");
  $("#single_answer").removeClass("active");
  $("#multiple_answer").removeClass("active");
  $("#yes_no").removeClass("active");
  $("#comment").addClass("active");
  $("#single_tap_question").remove();
  $("#multi_tap_question").remove();
  $("#yes_no_tap_question").remove();
}

function question_create_and_edit_tab_navigation(){
  $(".answer_navigation").change(function(){
    if($(this).val() == 'Single Answer'){
     $("#single_qst_tab").trigger('click');
    }else if($(this).val() == 'Multiple Answer'){
     $("#multiple_qst_tab").trigger('click');
    }else if($(this).val() == 'Yes/No'){
     $("#yes_no_tab").trigger('click');
    }else if($(this).val() == 'Comment'){
     $("#comment_tab").trigger('click');
    }
  })
}