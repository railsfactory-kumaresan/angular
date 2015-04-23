#CategoryType
category = ["Feedback","Innovation","Marketing"]
category.each do | category_name |
  CategoryType.where(category_name: category_name).first_or_create
end

#Question Types
question_types = ["Single Answer","Multiple Answer","Yes/no","Comments"]
question_types.each do |type|
  QuestionType.where(name: type).first_or_create
	#QuestionType.find_or_create_by_name(name: type)
end

#languages
languages = ["English","Tamil","Hindi","Kannada"]
languages.each do |language|
 Language.where(name: language).first_or_create
end

#Role insertion
roles =  ['Individual','Inquirly-Admin','Inquirly-Analyst','Super-Admin','Executive']
roles.each do |role|
 Role.where(name: role,is_default: true).first_or_create
end

FEATURE_PERMISSIONS.keys.each do |feature|
 feature_split =  feature.split("-")
 parent = Feature.where(parent_id: 0 ,controller_name: "#{feature_split[0]}",title: "#{feature_split[1]}",action_name: "#{feature_split[0]}").first_or_create
  FEATURE_PERMISSIONS[feature].each do |sub_feature|
   sub_split = sub_feature[0].split("-")
   Feature.where(parent_id: parent.id ,controller_name: "#{sub_split[0]}",action_name: "#{sub_split[1]}",title: "#{sub_split[2]}").first_or_create
  end
end



#Insert default permissions
permissions = PERMISSIONS.keys.each do |key|
 PERMISSIONS[key].each do |actions|
  controller = actions[0]
  actions[1].each do |action|
   permission_params = {}
   permission_map_params ={}
   role = Role.where(:name => key)[0]
   access_level = action[1] == 1 ? true : false
   permission_params.merge!("role_id" => role.id)
   permission_params.merge!("controller_name" => controller)
   permission_params.merge!("action_name" => action[0])
   permission_params.merge!("access_level" => access_level)
   Permission.where(permission_params).first_or_create
  end
 end
end


#To create default pricing plans
plan_hash = PLAN.keys.map{|i| PLAN[i]}
plan_hash.each do |plan_detail|
plan_params = {}
plan_detail.to_a.each do |p|
   plan_params.merge!("#{p[0]}" => p[1])
end
new_pricing_columns = ["business_type_id", "listener_slots", "crawler_slots", "email_alerts", "from_number", "redirect_url"]
plan_check_params = plan_params.reject{ |key| new_pricing_columns.include?(key) }
pricing_plan = PricingPlan.where(plan_check_params).first#.first_or_create
if pricing_plan.blank?
   pricing_plan = PricingPlan.new(plan_params)
   pricing_plan.save(:validate => false)
end
#if pricing_plan.id == 1
#  PricingCategoryType.where(pricing_plan_id: pricing_plan.id,category_type_id: 1).first_or_create
#else
  CategoryType.all.each do |type|
     PricingCategoryType.where(pricing_plan_id: pricing_plan.id,category_type_id: type.id).first_or_create
  end
#end
end


# Admin
unless User.where("admin",true).exists?
    resource = User.new(:first_name => "Admin", :last_name => "Admin", :email => "admin@inquirly.com", :password => "@Dmin1@#", :password_confirmation => "@Dmin1@#", :admin => true, :confirmed_at => Time.now, :step => "1", :is_active => true, :business_type_id => 4, :subscribe => true, :role_id => 2)
resource.save(:validate => false)
end

# #create test Individual User
#   user_details = {
#     "first_name"=> "Test",
#     "last_name" =>"Test",
#     "email"=>"Test_individual@gmail.com",
#     "company_name"=>"Inquirly",
#     "business_type_id"=>2,
#     "confirmed_at"=>Time.now.utc,
#     "password"=>"12345678aA!",
#     "password_confirmation"=>"12345678aA!",
#     "is_active"=>true,
#     "confirmation_sent_at"=>Time.now,
#     "exp_date"=>Time.now + 30.days,
#     "role_id" => 1
#   }
#   test_ind_user = User.where("email = ?","Test_individual@gmail.com")
#   unless test_ind_user.exists?
#    test_ind_user = User.new(user_details)
#    test_ind_user.save(:validate => false)
#    client_setting = ClientSetting.where(pricing_plan_id: 1, user_id: test_ind_user.id,tenant_count: 2,customer_records_count: 3,language_count: 1,business_type_id: 1).first_or_create
#    client_setting.update_attributes(language_ids:["1"])
#   end



  #create test Corp-Admin
  # corp_admin_user = {
  #   "first_name"=> "Test",
  #   "last_name" =>"Test",
  #   "email"=>"Test_corp_admin@gmail.com",
  #   "company_name"=>"Inquirly",
  #   "business_type_id"=>2,
  #   "confirmed_at"=>Time.now.utc,
  #   "password"=>"12345678aA!",
  #   "password_confirmation"=>"12345678aA!",
  #   "is_active"=>true,
  #   "confirmation_sent_at"=>Time.now,
  #   "exp_date"=>Time.now + 30.days,
  #   "role_id" => 4
  # }
  # test_corp_user = User.where("email = ?","Test_corp_admin@gmail.com")
  # unless test_corp_user.exists?
  #  test_corp_user = User.new(corp_admin_user)
  #  test_corp_user.save(:validate => false)
  #  client_setting = ClientSetting.where(pricing_plan_id: 2, user_id: test_corp_user.id,tenant_count: 2,customer_records_count: 5,language_count: 2,business_type_id: 2).first_or_create
  #  client_setting.update_attributes(language_ids:["1","2"])
  # end



    #create test tenant admin
 #  tenant_admin_user = {
 #    "first_name"=> "Test",
 #    "last_name" =>"Test",
 #    "email"=>"Test_tenant_admin@gmail.com",
 #    "company_name"=>"Inquirly",
 #    "business_type_id"=>2,
 #    "confirmed_at"=>Time.now.utc,
 #    "password"=>"12345678aA!",
 #    "password_confirmation"=>"12345678aA!",
 #    "is_active"=>true,
 #    "confirmation_sent_at"=>Time.now,
 #    "exp_date"=>Time.now + 30.days,
 #    "role_id"=> 6
 #  }
 #  test_tenant_user = User.where("email = ?","Test_tenant_admin@gmail.com")
 #  unless test_tenant_user.exists?
 #   test_tenant_user = User.new(tenant_admin_user)
 #   test_tenant_user.save(:validate => false)
 #   client_setting = ClientSetting.where(pricing_plan_id: 2, user_id: test_tenant_user.id,tenant_count: 2,customer_records_count: 1000,language_count: 2,business_type_id: 2).first_or_create
 #   client_setting.update_attributes(language_ids:["1","2"])
 # end

# Inquirly-Admin role
  inq_admin = User.where("email = ?","inq-admin@inquirly.com")
 unless inq_admin.exists?
  resource = User.new(:first_name => "Inquirly", :last_name => "Admin", :email => "inq-admin@inquirly.com", :password => "admin123", :password_confirmation => "admin123", :admin => true, :confirmed_at => Time.now, :step => "1", :is_active => true, :business_type_id => 4, :subscribe => true, :role_id => 2)
  resource.save(:validate => false)
end

# Inquirly-Analyst role
inq_analyst = User.where("email = ?","inq-analyst@inquirly.com")
unless inq_analyst.exists?
  resource = User.new(:first_name => "Inquirly", :last_name => "Analyst", :email => "inq-analyst@inquirly.com", :password => "admin123", :password_confirmation => "admin123", :admin => true, :confirmed_at => Time.now, :step => "1", :is_active => true, :business_type_id => 4, :subscribe => true, :role_id => 3)
  resource.save(:validate => false)
end

CronLog.where(log_type: 'QuestionViewLog').first_or_create
CronLog.where(log_type: 'QuestionResponseLog').first_or_create
CronLog.where(log_type: 'AnswerAnalysis').first_or_create

#DbViews.new.perform

#To create default distribute pricing plans details
plan_details = DISTRIBUTE_PLAN.keys.map{|i| DISTRIBUTE_PLAN[i]}
plan_details.each do |plan_detail|
  plan_params = {}
  plan_detail.to_a.each { |p| plan_params.merge!("#{p[0]}" => p[1]) }
  pricing_plan = DistributePricingPlan.where(plan_params).first
  if pricing_plan.blank?
    pricing_plan = DistributePricingPlan.new(plan_params)
    pricing_plan.save(:validate => false)
  end
end