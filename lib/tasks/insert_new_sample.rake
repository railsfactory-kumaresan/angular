require 'rubygems'
require 'faker'

desc "Creating a sample data's"
task :insert_sample_data, [:question_count,:sharing_count,:category_type_id ,:answer_type_id, :expiration, :expiration_date, :expire_time,:share_provider] => [:environment] do |t,params|
  # Creating User
  #======================#
  @user = 0
  @providers = params[:share_provider].split("&")
  @created_date = Time.now.ago(335.days)
  @countries = ['IN','US','CN','UK']
  @gender = ["Male", "Female"]
  @question_count = params[:question_count].to_i
  @sharing_count = params[:sharing_count].to_i
  @category_type_id = params[:category_type_id].to_i
  @answer_type_id = params[:answer_type_id].to_i
  @category_type_name = CategoryType.find(@category_type_id).category_name
  @answer_type_name = QuestionType.find(@answer_type_id).name
  @expiration = case  params[:expiration]
  when "1 Day"
    e_day = 1
  when "1 Week"
    e_day = 7
  when "1 Month"
    e_day = 30
  when "1 Year"
    e_day =365
  end
  date_time = params[:expiration_date] +" " +  params[:expire_time]
  @expiration_date =  date_time
  @created_at_op = Time.parse("#{date_time}") - e_day.to_i.days
  @question_created_date =  (Time.parse("#{date_time}") - e_day.to_i.days) .to_s(:db)
  @share_status = params[:share_status]
  user_details = {
    "first_name"=> "Sudha",
    "last_name" =>"Test",
    "email"=>"manimaransudha@gmail.com",
    "company_name"=>"Inquirly",
    "business_type_id"=>2,
    "confirmed_at"=>@created_date,
    "password"=>"12345678aA!",
    "password_confirmation"=>"12345678aA!",
    "is_active"=>true,
    "confirmation_sent_at"=>Time.now,
    "exp_date"=>Time.now + 30.days,
    "role_id" => 4,
    "parent_id" => 0
  }
	user_exist = User.where("email ='#{user_details["email"]}'")
	if !user_exist.present?
    @user = User.new(user_details)
    @user.created_at = "2014-01-01".to_datetime
    @user.save
   client_setting = ClientSetting.where(pricing_plan_id: 2, user_id: @user.id,tenant_count: 2,customer_records_count: 5,language_count: 2,business_type_id: 2).first_or_create
   client_setting.update_attributes(language_ids:["1","2"])
	else
    @user = User.find_by_email("manimaransudha@gmail.com")
   # @user.created_at = Date.today - 1.year
   # @user.save
  end

  # Creating Tenants
  name = ["Chennai", "Bengalore", "Delhi"]
  (0..name.length - 1).each do |n|
    tenant = Tenant.where(name: name[n], client_id: @user.id, is_active: true).first_or_create
    ExecutiveTenantMapping.where(user_id: @user.id, tenant_id: tenant.id).first_or_create
  end


  # Creating Questions
  #======================#
  faker_hash_feed_back = []
  faker_hash_multiple = []
  faker_hash_yes_no = []
  faker_hash_comment = []
  option_hash = []
  share_hash = []
  cookie_token_hash = []
  answer_hash = []
  response_customer_info_values  = []
  response_cookie_info = []
  question_view_logs = []
  question_response_logs = []

  # Creating Feedback Questions
  #======================#

  counter_provider = Question.last ? Question.last.id  : 0
  #@question_count.times do
    provider_name = @providers[counter_provider % @providers.count]
    faker_hash_feed_back << {:category_type_id  => @category_type_id, :expiration_id => "#{params[:expiration]}", :question => "#{provider_name.first}_#{@category_type_name.first}_#{@answer_type_name.first}_#{counter_provider}" , :video_type => 0, :embed_url => "", :include_text => 0, :question_type_id => @answer_type_id, :thanks_response => 'Thanks for responding!', :user_id => @user.id ,:created_at => @question_created_date, :updated_at =>@question_created_date, :status => 'Active', :expired_at => @expiration_date ,:slug => SecureRandom.urlsafe_base64(nil, false)}
    counter_provider = counter_provider + 1
  #end

  #faker_hash_feed_back.each do |row|
    @ques = Question.create(faker_hash_feed_back)[0]
  #end
  #Question.import  batch

 # question_list = Question.where("user_id =? ",@user.id) #@question_count
  @id = QuestionOption.last.blank? ?  0 : QuestionOption.last.id
  @coo_id  = CookieToken.last.blank? ? 0 : CookieToken.last.id
  @res_cus_id = ResponseCustomerInfo.last.blank? ? 0 : ResponseCustomerInfo.last.id
  #question option create
  #question_list.each do |i|
    if @answer_type_id != 4
      @option = ["Yes", "No"]  if @answer_type_id == 3
      @option = ["#{Faker::Name.name}", "#{Faker::Name.name}"] if @answer_type_id != 3
      @option.each do |option|
        option_hash << {:question_id=>@ques.id,:option=> option ,:created_at=>@question_created_date,:updated_at=>@question_created_date,:is_other=>false,:is_deactivated=>false}
      end
   # end

    counter = 0
    share_provider = @sharing_count.to_i  /  @providers.count
    @providers.each do |r|
      share_provider.times do
        @id += 1
        @coo_id += 1 #if r != 'embed'
        @res_cus_id  +=  1 # if r != 'embed'
        #@month = [30,40,50,20,10,60,70,80,90,100,110,120,130,150,300,120,130,140,150,200,210,220,260,280].sample if @expiration == 365
        #@month = [30,40,50,20,10,60].sample if @expiration == 365
        #@month = [5,10,15,20,25,30].sample if @expiration == 30
        @month = [1,2,3,4,5,6,7,8,9,10].sample #if @expiration == 7
        @month = 0 if @expiration == 1
        @created_at = @created_at_op + @month.days
        share_hash <<	 {:provider => r , :email_address => Faker::Internet.email , :created_at => @created_date, :updated_at => @created_date}
        cookie_token_hash << { :uuid => SecureRandom.hex(10), :created_at => @created_date, :updated_at  => @created_date}
        response_customer_info_values << {:customer_name => Faker::Lorem.words(2).join(" ") , :email => Faker::Internet.email, :age => rand.to_s[2..3], :country => @countries[counter % 4], :gender => @gender.sample, :created_at => @created_at , :updated_at => @created_at, :cookie_token_id => @coo_id} #if r !="embed"
        counter = counter + 1 #if r !="embed"
        response_cookie_info << {:cookie_token_id =>@coo_id,:response_token_id => @coo_id, :response_token_type => "ResponseCustomerInfo" , :created_at => @created_at , :updated_at => @created_at}
        question_view_logs << {:provider => r ,:question_id => @ques.id , :cookie_token_id => @coo_id, :user_id => @user.id , :created_at => @created_at , :updated_at => @created_at }
        total_response_count = (0.8 * @sharing_count).round
        if question_response_logs.length < (total_response_count)
        if @answer_type_id != 4
          rand_index = ((rand*2).to_i + 1) -1
          answer_hash << {:is_business_user => false,:question_type_id =>@ques.question_type_id, :question_option_id => @id , :question_id => @ques.id, :provider => r , :option => @option[((rand*2).to_i + 1) -1] , :is_deactivated => false,  :created_at => @created_at, :updated_at => @created_at , :uuid => @coo_id, :customers_info_id => @res_cus_id } #r != 'embed' ? @res_cus_id : nil }
          #answer_hash << {:is_business_user => false,:question_type_id => i.question_type_id, :question_option_id => @id , :question_id => i.id, :provider => r , :option => @option[((rand*2).to_i + 1) -1] , :is_deactivated => false,  :created_at => @created_at, :updated_at => @created_at , :uuid => @id, :customers_info_id => @id  }
        else
          answer_hash << {:is_business_user => false,:question_type_id => @ques.question_type_id, :comments => Faker::Lorem.words(2).join(" "), :question_id => @ques.id, :provider => r  , :is_deactivated => false,  :created_at => @created_at, :updated_at => @created_at , :uuid =>@coo_id, :customers_info_id => @res_cus_id  }
        end
        question_response_logs << {:provider => r ,:question_id => @ques.id, :cookie_token_id => @coo_id, :user_id => @user.id , :created_at => @created_at , :updated_at => @created_at } #if r != "embed"
       end
      end
      # @sharing_count-1.times do
      #   @id1 += 1
      #   question_response_logs << {:provider => r ,:question_id => i.id , :cookie_token_id => @id1 , :user_id => @user.id , :created_at => @created_at , :updated_at => @created_at }
      # end
    end
  end

  if @answer_type_id != 4
    batch = []
    option_hash.each do |i|
      QuestionOption.create(i)
    end
    #QuestionOption.import  batch
  end
  batch =[]
  share_hash.each do |i|
    ShareQuestion.create(i)
  end
  #ShareQuestion.import batch

  batch =[]
  cookie_token_hash.each do |i|
    CookieToken.create(i)
  end
  #CookieToken.import batch


   batch =[]
  question_view_logs.each do |i|
    QuestionViewLog.create(i)
    #sleep 5
  end


    batch =[]
  response_cookie_info.each do |i|
    ResponseCookieInfo.create(i)
  end

    batch =[]
  response_customer_info_values.each do |i|
    ResponseCustomerInfo.create(i)
  end

   batch =[]
  question_response_logs.each do |i|
    QuestionResponseLog.create(i)
    #sleep 5
  end

  start_answer_redis = Answer.last.blank? ? 1 : Answer.last.id + 1
  batch =[]
  answer_hash.each do |i|
    Answer.create(i)
  end
  # Answer.import batch


  #ResponseCustomerInfo.import batch


  #ResponseCookieInfo.import batch


  #QuestionViewLog.import batch


  #QuestionResponseLog.import batch

  # QuestionResponseLog.where(id: (start_answer_redis ..QuestionResponseLog.last.id)).each do |i|
  #   i.index
  # end
  # QuestionViewLog.where(id: (start_answer_redis..QuestionViewLog.last.id)).each do |i|
  #   i.index
  # end

  #Question.reindex(:batch_size => 10 )

  # Answer.where(id: (start_answer_redis..Answer.last.id)).each do |i|
  #   i.index
  # end
  # ResponseCustomerInfo.where(id: (start_answer_redis..ResponseCustomerInfo.last.id)).each do |i|
  #   provider = Answer.where("customers_info_id = #{i.id}").first.provider
  #   i.index if provider != 'embed'
  # end

  #~ #QuestionResponseLog.reindex(:batch_size => 100 )
  #~ QuestionViewLog.reindex(:batch_size => 100 )

  #~ Answer.reindex(:batch_size => 100 )
  #~ ResponseCustomerInfo.reindex(:batch_size => 100 )
  #puts Benchmark.measure {incre_redis(start_answer_redis, Answer.last.id,@user.id)}
end


# # def incre_redis(start,last,user_id)
# #   answers= Answer.where(id: (start..last))
# #   answers.each do |answer|
# # 	  question = answer.question
# # 	  @question_id = question.id
# # 	  @provider = answer.provider
# # 	  @user_id = user_id
# # 	  @uuid = answer.uuid
# # 	  @created_date = answer.created_at
# # 	  @category = question.category_type_id
# # 	  @age = answer.customer_info.age if @provider != 'embed'
# # 	  @gender = answer.customer_info.gender if @provider != 'embed'
# # 	  @country = answer.customer_info.country if @provider != 'embed'
# # 	  keys = []
# #     keys << ["question_view_#{@question_id}","question_view_#{@question_id}_#{@provider}","question_view_#{@question_id}_#{@created_date.to_date.strftime('%Y/%m/%d')}","question_view_#{@question_id}_#{@provider}_#{@created_date.to_date.strftime('%Y/%m/%d')}","question_view_#{@question_id}_#{@created_date.to_date.strftime('%Y/%m')}","question_view_#{@question_id}_#{@created_date.to_date.strftime('%Y')}","question_view_#{@question_id}_#{@created_date.to_date.strftime('%Y/%m/%d')}_#{@category}","question_view_#{@question_id}_#{@created_date.to_date.strftime('%Y/%m')}_#{@category}","question_view_#{@question_id}_#{@created_date.to_date.strftime('%Y')}_#{@category}","question_view_#{@question_id}_#{@provider}_#{@created_date.to_date.strftime('%Y/%m/%d')}_#{@category}","question_total_view_#{@user_id}","question_total_view_#{@user_id}_#{@category}","question_total_view_#{@user_id}_#{@provider}","question_total_view_#{@user_id}_#{@provider}_#{@category}","question_total_view_#{@user_id}_#{@created_date.to_date.strftime('%Y/%m/%d')}","question_total_view_#{@user_id}_#{@created_date.to_date.strftime('%Y/%m')}","question_total_view_#{@user_id}_#{@created_date.to_date.strftime('%Y')}","question_total_view_#{@user_id}_#{@created_date.to_date.strftime('%Y/%m/%d')}_#{@category}","question_total_view_#{@user_id}_#{@created_date.to_date.strftime('%Y/%m')}_#{@category}","question_total_view_#{@user_id}_#{@created_date.to_date.strftime('%Y')}_#{@category}","question_total_view_#{@user_id}_#{@provider}_#{@created_date.to_date.strftime('%Y/%m/%d')}","question_total_view_#{@user_id}_#{@provider}_#{@created_date.to_date.strftime('%Y/%m/%d')}_#{@category}"]

# #     keys << ["question_response_#{@question_id}","question_response_#{@question_id}_#{@provider}","question_response_#{@question_id}_#{@created_date.to_date.strftime('%Y/%m/%d')}","question_response_#{@question_id}_#{@provider}_#{@created_date.to_date.strftime('%Y/%m/%d')}","question_response_#{@question_id}_#{@created_date.to_date.strftime('%Y/%m')}","question_response_#{@question_id}_#{@created_date.to_date.strftime('%Y')}","question_response_#{@question_id}_#{@created_date.to_date.strftime('%Y/%m/%d')}_#{@category}","question_response_#{@question_id}_#{@created_date.to_date.strftime('%Y/%m')}_#{@category}","question_response_#{@question_id}_#{@created_date.to_date.strftime('%Y')}_#{@category}","question_response_#{@question_id}_#{@provider}_#{@created_date.to_date.strftime('%Y/%m/%d')}_#{@category}","question_total_response_#{@user_id}","question_total_response_#{@user_id}_#{@category}","question_total_response_#{@user_id}_#{@provider}","question_total_response_#{@user_id}_#{@provider}_#{@category}","question_total_response_#{@user_id}_#{@created_date.to_date.strftime('%Y/%m/%d')}","question_total_response_#{@user_id}_#{@provider}_#{@created_date.to_date.strftime('%Y/%m/%d')}","question_total_response_#{@user_id}_#{@created_date.to_date.strftime('%Y/%m')}","question_total_response_#{@user_id}_#{@created_date.to_date.strftime('%Y')}","question_total_response_#{@user_id}_#{@created_date.to_date.strftime('%Y/%m/%d')}_#{@category}","question_total_response_#{@user_id}_#{@created_date.to_date.strftime('%Y/%m')}_#{@category}","question_total_response_#{@user_id}_#{@created_date.to_date.strftime('%Y')}_#{@category}","question_total_response_#{@user_id}_#{@provider}_#{@created_date.to_date.strftime('%Y/%m/%d')}_#{@category}"]

# # p "-------------------"
# #    p keys << ["question_view_#{@question_id}_#{@country}","question_view_#{@question_id}_#{@country}_#{@created_date.to_date.strftime('%Y/%m/%d')}","question_total_view_#{@user_id}_#{@country}","question_total_view_#{@user_id}_#{@country}_#{@category}","question_view_#{@question_id}_#{@country}_#{@created_date.to_date.strftime('%Y/%m/%d')}_#{@category}","question_total_view_#{@user_id}_#{@country}_#{@created_date.to_date.strftime('%Y/%m/%d')}_#{@category}"] if @provider != 'embed'


# # #    RedisCount::RedisKeyIncrement.new(keys.flatten).increment_keys
# #     increase_response_count_by_age if @provider != "embed"
# #     increase_unknown_view_count if  @provider == "embed"
# #     print "done with #{answer.id}.............\r"

# #   end
# end

# def increase_response_count_by_age
#   case @age.to_i
#   when 0..17
#     increase_age_count(@question_id,@user_id,"0_to_17",@gender,@created_date,@category)
#   when 18..25
#     increase_age_count(@question_id,@user_id,"18_to_25",@gender,@created_date,@category)
#   when 26..30
#     increase_age_count(@question_id,@user_id,"26_to_30",@gender,@created_date,@category)
#   when 31..35
#     increase_age_count(@question_id,@user_id,"31_to_35",@gender,@created_date,@category)
#   when 36..40
#     increase_age_count(@question_id,@user_id,"36_to_40",@gender,@created_date,@category)
#   when 41..45
#     increase_age_count(@question_id,@user_id,"41_to_45",@gender,@created_date,@category)
#   when 46..50
#     increase_age_count(@question_id,@user_id,"46_to_50",@gender,@created_date,@category)
#   when 51..300
#     increase_age_count(@question_id,@user_id,"51_to_300",@gender,@created_date,@category)
#   end
# end


# def increase_unknown_view_count
#   key = ["unknown_view_#{@question_id}","unknown_total_view_#{@user_id}","unknown_view_#{@question_id}_#{@created_date.to_date.strftime('%Y/%m/%d')}_#{@category}","unknown_total_view_#{@user_id}_#{@created_date.to_date.strftime('%Y/%m/%d')}_#{@category}","unknown_total_view_#{@user_id}_#{@category}"]
# #  RedisCount::RedisKeyIncrement.new(key).increment_keys if @provider == 'embed'
# end


# def increase_age_count(question_id,user_id,age_limit,gender,created_date=nil,category=nil)
#   keys = ["question_response_#{question_id}_#{age_limit}_#{gender}","question_total_response_#{user_id}_#{age_limit}_#{gender}","question_total_response_#{user_id}_#{age_limit}_#{gender}_#{category}","question_response_#{question_id}_#{age_limit}_#{gender}_#{created_date.to_date.strftime('%Y/%m/%d')}","question_response_#{question_id}_#{age_limit}_#{gender}_#{created_date.to_date.strftime('%Y/%m/%d')}_#{category}","question_total_response_#{user_id}_#{age_limit}_#{gender}_#{created_date.to_date.strftime('%Y/%m/%d')}","question_total_response_#{user_id}_#{age_limit}_#{gender}_#{created_date.to_date.strftime('%Y/%m/%d')}_#{category}"]
# #  RedisCount::RedisKeyIncrement.new(keys).increment_keys #if @sample_question_view_date.blank?
#   keys = ["question_view_#{question_id}_#{age_limit}_#{gender}","question_total_view_#{user_id}_#{age_limit}_#{gender}","question_total_view_#{user_id}_#{age_limit}_#{gender}_#{category}","question_view_#{question_id}_#{age_limit}_#{gender}_#{created_date.to_date.strftime('%Y/%m/%d')}","question_view_#{question_id}_#{age_limit}_#{gender}_#{created_date.to_date.strftime('%Y/%m/%d')}_#{category}","question_total_view_#{user_id}_#{age_limit}_#{gender}_#{created_date.to_date.strftime('%Y/%m/%d')}","question_total_view_#{user_id}_#{age_limit}_#{gender}_#{created_date.to_date.strftime('%Y/%m/%d')}_#{category}"]
#  # RedisCount::RedisKeyIncrement.new(keys).increment_keys
#   #return keys
# end