class PrivilegeController < ApplicationController
  #include PrivilegeHelper

  private

  # Check current user can access the question
  def check_current_user_question
    question_id =  params[:question_id] || params[:id]
    question = Question.get_question("#{question_id}")
    # Checking Executive Tenant mapped Users of the Current question
    executive_user = ExecutiveTenantMapping.where(tenant_id: question.tenant_id).first
    if  question.nil? || question.user_id != @current_user.id || question.status == "Closed" || (executive_user && executive_user.user_id == current_user.id)
      flash[:notice] = "#{APP_MSG['authorization']['failure']}"
      respond_format
    end
  end


  def check_privileges
   @show_video_photo = current_user.check_action_privilege('video_photo_count')
   @languages = current_user.get_selected_languages('languages')
  end

  # Check the current user has the right to share the question
  def check_current_user_share_access(type)
    unless current_user.check_privilege(type)
      respond_format
    end
  end

  def get_share_privileges
   @show_social = current_user.check_privilege('social_share')
   @show_embed = current_user.check_privilege('embed_share')
   @show_qr = current_user.check_privilege('qr_share')
   @show_email = current_user.check_action_privilege('email_count')
   @show_call= current_user.check_action_privilege('call_count')
   @show_sms = current_user.check_action_privilege('sms_count')
  end

  def get_show_privileges
   @show_social = current_user.check_privilege('social_share')
   @show_embed = current_user.check_privilege('embed_share')
   @show_qr = current_user.check_privilege('qr_share')
   @show_email = current_user.check_privilege('email_count')
   @show_call= current_user.check_privilege('call_count')
   @show_sms = current_user.check_privilege('sms_count')
 end

  def set_maximum_limit
   @maximum_limit = current_user.get_maximum_limit(params["share"])
  end

  def respond_format
    respond_to do |format|
      format.json { render json: failure({error: "Access Denied."}) }
      format.html { redirect_to "/question"}
    end
  end
end

