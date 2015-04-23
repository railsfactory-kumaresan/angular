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
languages = ["English","Tamil","Hindi","Bengali","Gujarati"]
languages.each do |language|
 Language.where(name: language).first_or_create
end

#Role insertion
roles =  ['Individual','Inquirly-Admin','Inquirly-Analyst','Corp-Admin','Corp-Exec','Tenant-Admin','Tenant-Manager','Tenant-Analyst']
roles.each do |role|
 Role.where(name: role,is_default: true).first_or_create
end

#Insert default permissions
permissions = PERMISSIONS.keys.each do |key|
 PERMISSIONS[key].each do |actions|
  controller = actions[0]
  actions[1].each do |action|
   permission_params = {}
   role = Role.where(:name => key)[0]
   permission_params.merge!("role_id" => role.id)
   permission_params.merge!("controller_name" => controller)
   permission_params.merge!("action_name" => action[0])
   permission_params.merge!("access_level" => action[1])
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
 pricing_plan = PricingPlan.where(plan_params).first_or_create
if pricing_plan.id == 1
  PricingCategoryType.where(pricing_plan_id: pricing_plan.id,category_type_id: 1).first_or_create
 else
  CategoryType.all.each do |type|
     PricingCategoryType.where(pricing_plan_id: pricing_plan.id,category_type_id: type.id).first_or_create
  end
end
end



# Admin
unless User.where("admin",true).exists?
resource = User.new(:first_name => "Admin", :last_name => "Admin", :email => "admin@inquirly.com", :password => "admin123", :password_confirmation => "admin123", :admin => true, :confirmed_at => Time.now, :step => "1", :is_active => true, :business_type_id => 4, :subscribe => true)
resource.save(:validate => false)
end

#create test Individual User
  user_details = {
    "first_name"=> "Test",
    "last_name" =>"Test",
    "email"=>"Test_individual@gmail.com",
    "company_name"=>"Inquirly",
    "business_type_id"=>2,
    "confirmed_at"=>Time.now.utc,
    "password"=>"12345678aA!",
    "password_confirmation"=>"12345678aA!",
    "is_active"=>true,
    "confirmation_sent_at"=>Time.now,
    "exp_date"=>Time.now + 30.days,
    "role_id" => 1
  }
  test_ind_user = User.where("email = ?","Test_individual@gmail.com")
  unless test_ind_user.exists?
   test_ind_user = User.new(user_details)
   test_ind_user.save(:validate => false)
   client_setting = ClientSetting.where(pricing_plan_id: 1, user_id: test_ind_user.id,tenant_count: 2,customer_records_count: 1000,language_count: 2,business_type_id: 1).first_or_create
   client_setting.update_attributes(language_ids:["1","2"])
  end



  #create test Corp-Admin
  corp_admin_user = {
    "first_name"=> "Test",
    "last_name" =>"Test",
    "email"=>"Test_corp_admin@gmail.com",
    "company_name"=>"Inquirly",
    "business_type_id"=>2,
    "confirmed_at"=>Time.now.utc,
    "password"=>"12345678aA!",
    "password_confirmation"=>"12345678aA!",
    "is_active"=>true,
    "confirmation_sent_at"=>Time.now,
    "exp_date"=>Time.now + 30.days,
    "role_id" => 4
  }
  test_corp_user = User.where("email = ?","Test_corp_admin@gmail.com")
  unless test_corp_user.exists?
   test_corp_user = User.new(corp_admin_user)
   test_corp_user.save(:validate => false)
   client_setting = ClientSetting.where(pricing_plan_id: 2, user_id: test_corp_user.id,tenant_count: 2,customer_records_count: 1000,language_count: 2,business_type_id: 2).first_or_create
   client_setting.update_attributes(language_ids:["1","2"])
  end



    #create test tenant admin
  tenant_admin_user = {
    "first_name"=> "Test",
    "last_name" =>"Test",
    "email"=>"Test_tenant_admin@gmail.com",
    "company_name"=>"Inquirly",
    "business_type_id"=>2,
    "confirmed_at"=>Time.now.utc,
    "password"=>"12345678aA!",
    "password_confirmation"=>"12345678aA!",
    "is_active"=>true,
    "confirmation_sent_at"=>Time.now,
    "exp_date"=>Time.now + 30.days,
    "role_id"=> 6
  }
  test_tenant_user = User.where("email = ?","Test_tenant_admin@gmail.com")
  unless test_tenant_user.exists?
   test_tenant_user = User.new(tenant_admin_user)
   test_tenant_user.save(:validate => false)
   client_setting = ClientSetting.where(pricing_plan_id: 2, user_id: test_tenant_user.id,tenant_count: 2,customer_records_count: 1000,language_count: 2,business_type_id: 2).first_or_create
   client_setting.update_attributes(language_ids:["1","2"])
  end