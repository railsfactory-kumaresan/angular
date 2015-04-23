module UserPrivilege
  extend ActiveSupport::Concern
  included do

  def restrict_question_privilege
    user = check_multitenant_user(self)
    plan_question_count = ClientSetting.get_column_value("questions_count",user)
    #Check aggregate questions Count
    user_id = []
    if self.parent_id == 0 && self.parent_id != nil
      user_id = User.where(parent_id: self.id).map(&:id) << self.id
    elsif self.parent_id != 0 && self.parent_id != nil
      user_id = User.where(parent_id: self.parent_id).map(&:id) << self.parent_id
    else
      user_id = self.id
    end
    # comment this for question count restriction issue
    #~ restrict = (plan_question_count > 0 && Question.get_monthly_count(user_id) >= plan_question_count) ? true : false
    created_count = (user.share_detail && user.share_detail.questions_count.present? ) ? user.share_detail.questions_count : 0
    restrict = (plan_question_count > 0 && created_count >= plan_question_count) ? true : false
  end

 def check_privilege(column)
   user = check_multitenant_user(self)
   if user.client_setting
     count_columns =  ['sms_count','call_count','email_count','video_photo_count','language_count','customer_records_count']
     if count_columns.include?(column)
       allocated_count = user.get_allocated_count(column)
       allocated_count > 0 ? true : false
     else
       ClientSetting.get_column_value(column,user) ? true : false
     end
   end
end

def check_action_privilege(column)
  user = check_multitenant_user(self)
  if user.check_privilege(column)
    allocated_count = user.get_allocated_count(column)
    shared_count = user.get_shared_count(column)
    allocated_count > shared_count ? true : 'disable'
  else
    false
  end
end

def get_shared_count(column)
  user = check_multitenant_user(self)
  share_detail = user.share_detail
  shared_count = !share_detail.blank? ? share_detail.send(column) : 0
end


def get_maximum_limit(column)
  user = check_multitenant_user(self)
  user.get_allocated_count(column) - user.get_shared_count(column)
end

def get_allocated_count(column)
  user = check_multitenant_user(self)
  ClientSetting.get_column_value(column,user)
end

def get_category_type_id(question)
  user = check_multitenant_user(self)
  category_types = ClientSetting.get_column_value('categories',self)
  return category_types.include?(question.category_type_id) ? question.category_type_id : category_types.first.id
end

def get_selected_languages(column)
  user = check_multitenant_user(self)
  ids = ClientSetting.get_column_value(column,user)
  Language.get_language_names(ids)
end

def get_tenant_count_limit
  user  = check_multitenant_user(self)
  allowed_tenant_count = ClientSetting.get_column_value("tenant_count",user)
  tenant_count = Tenant.where(client_id: user.id).count
  return (tenant_count >= allowed_tenant_count) ? false : true
end

private
def check_multitenant_user(user)
  return (self.parent_id != 0 && self.parent_id != nil) ? User.where(id: self.parent_id).first : self
end

end
end