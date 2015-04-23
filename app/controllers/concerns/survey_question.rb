module SurveyQuestion
  extend ActiveSupport::Concern
  included do

    def show_survey_question(params)
      if @question.present?
        @question.update_status_with_expired_at if params[:provider] == "QR" && @question.status.include?("Inactive")
        @thanks_msg = @question.thanks_response
        @question_options = QuestionOption.options_without_other(@question.id)
        @provider = params[:provider] if params[:provider]
        @is_answered = check_cookie_already_answered(@question.id,@provider)
        check_cookie_details(params)
        @question_options = QuestionOption.options_without_other(@question.id)
        @answer_id= params[:answer_id]
        @user_company=@question.user.company_name
        @attachment = @question.attachment.image(:thumb) if @question.attachment.present? && @question.attachment.image.present? && @question.attachment.image.url.present?
        @question_style = @question.question_style
        respond_to do |format|
          format.js
        end
      end
    end

 end
end