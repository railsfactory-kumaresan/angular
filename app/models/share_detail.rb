class ShareDetail < ActiveRecord::Base

belongs_to :user

def self.get_column(column)
  COLUMN_NAME["column_settings"][column]
end

def self.update_share_count(user,count,column)
  user = (user.parent_id != 0 && user.parent_id != nil) ? User.where(id: user.parent_id).first : user
  column = ShareDetail.get_column(column)
  user_share_detail = ShareDetail.where("user_id = ?",user.id)
  share_detail =  user_share_detail.blank? ? new_record(user) : user_share_detail.first
  ShareSummary.create_monthly_record(user.id,share_detail) if (share_detail.updated_at.month != Time.now.utc.month && share_detail.updated_at.year != Time.now.utc.year)
  count = count + share_detail.send("#{column}")
  share_detail.update_attributes("#{column}" => count)
  if column == "questions_count"
    own_questions = Question.where(user_id: user.id).count
    tenant_users = user.parent_id == 0 ? User.where(parent_id: user.id).map(&:id) : []
    tenant_questions = Question.where(user_id: tenant_users).count
    if share_detail.questions_count != (own_questions + tenant_questions)
      InviteUser.share_detail_count_mismatch(user).deliver
    end
  end
end

  def self.new_record(user)
    create(user_id: user.id,customer_records_count: 0,questions_count: 0,video_photo_count: 0,sms_count: 0,call_count: 0,email_count: 0)
  end

end
