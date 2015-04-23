class EmailActivity < ActiveRecord::Base

  belongs_to :user
  belongs_to :question
  belongs_to :business_customer_info

  def self.save_payload(event_data)
    event_data.each do |data|
      if data["msg"] && !data["msg"]["metadata"].blank?
       biz_id = BusinessCustomerInfo.where(email: data["msg"]["email"], user_id: data["msg"]["metadata"]["user_id"]).first.try(:id)
       create_or_update(data,biz_id,data["msg"]["metadata"]["user_id"],data["msg"]["metadata"]["question_id"]) unless biz_id.nil?
      end
    end
  end

  def self.create_or_update(data,biz_cus_id,user_id,question_id)
    activity = where(business_customer_info_id: biz_cus_id, user_id: user_id, question_id: question_id).first
    if data["event"] == "open"
      if activity.blank?
        create(business_customer_info_id: biz_cus_id, user_id: user_id, question_id: question_id, opens: 1)
      else
        activity.update_columns(business_customer_info_id: biz_cus_id, user_id: user_id, question_id: question_id, opens: activity.opens + 1, clicks: activity.clicks)
      end
    elsif data["event"] == "click"
      if activity.blank?
        create(business_customer_info_id: biz_cus_id, user_id: user_id, question_id: question_id, clicks: 1)
      else
        activity.update_columns(business_customer_info_id: biz_cus_id, user_id: user_id, question_id: question_id, opens: activity.opens, clicks: activity.clicks + 1)
      end
    end
  end
end