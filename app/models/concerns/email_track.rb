module EmailTrack
  extend ActiveSupport::Concern
  included do

    def self.fetch_activity_results(params,type)
      questions = where(:slug => params["slug"])
      if type == "opens"
       result = questions.joins(:email_activities => :business_customer_info).joins("FULL OUTER JOIN tenants on questions.tenant_id = tenants.id").where("email_activities.business_customer_info_id is not null and email_activities.opens >= 1")
      else
       result = questions.joins(:email_activities => :business_customer_info).joins("FULL OUTER JOIN tenants on questions.tenant_id = tenants.id").where("email_activities.business_customer_info_id is not null and email_activities.clicks >= 1")
      end
      result = result.get_activity_at_country(params) unless params["country"].blank?
      result.select("row_number() OVER () AS id,business_customer_infos.id AS customer_id, questions.user_id as user_id, questions.question as question, questions.tenant_id as tenant_id, tenants.name as tenant_name, email_activities.updated_at AT TIME ZONE 'UTC' AT  TIME ZONE 'Asia/Calcutta' as date, email_activities.question_id AS question_id,email_activities.opens AS opens,email_activities.clicks AS clicks, business_customer_infos.country AS country, business_customer_infos.state AS state, business_customer_infos.city AS city, business_customer_infos.area AS area, business_customer_infos.customer_name AS name, business_customer_infos.email AS email, business_customer_infos.mobile AS mobile, business_customer_infos.age AS age, business_customer_infos.gender AS gender, business_customer_infos.custom_field AS custom_field")
    end

    def self.get_activity_at_country(params)
      result = self.where("country = ?", params["country"])
      result = self.where("category_type_id = ?", params["category_id"]) unless params["category_id"].blank?
      if params["from_date"].present? && params["to_date"].present?
        from_date,to_date = "#{params["from_date"]} 00:00:00","#{params["to_date"]} 23:59:59"
        result = self.where("(email_activities.created_at BETWEEN ? AND ?) AND (questions.created_at BETWEEN ? AND ?)", from_date,to_date,from_date,to_date)
      end
      result
    end

  end
end