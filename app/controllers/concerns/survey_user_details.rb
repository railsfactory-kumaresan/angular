module SurveyUserDetails
  extend ActiveSupport::Concern
  included do

    def check_cookie_details(params)
      res = !params[:provider].nil? && @question.status !="Closed"
      if res && !check_cookie_already_viewed(@question.id,params[:provider])
        set_cookie_and_uuid(@cookie_uuid, @question,params[:provider])
        cid_present(params)
        view_id = QuestionViewLog.create_new_record(@question,params[:provider],@customer.try(:id))
        session[:q_v_id] = view_id unless view_id.nil?
      end
    end

    def cid_present(params)
      customer_info = params[:cid].present? ? params[:cid] : (cookies.signed[:customer_details].present? ? cookies.signed[:customer_details] : '')
      @customer = BusinessCustomerInfo.get_customer_info(customer_info)
      @get_email = false
    end
  end
end