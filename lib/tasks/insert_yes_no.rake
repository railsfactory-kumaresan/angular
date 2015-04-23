

desc "insert_yes_no"

task :insert_yes_no , [:question_count,:sharing_count] => [:environment] do |t,params|

  @user = 0
  @providers = %w(Email Twitter Linkedin Sms Facebook)
  @created_date = Time.now.ago(335.days)
  @countries = ['IN','US','CN','UK']
  @gender = ["Male", "Female"]
  @question_count = params[:question_count].to_i
  @sharing_count = params[:sharing_count].to_i
  user_details = {
    "first_name"=> "Nandhini",
    "last_name" =>"Ram",
    "email"=>"nandhini@railsfactory3.org",
    "company_name"=>"Rails",
    "business_type_id"=>2,
    "confirmed_at"=>@created_date,
    "password"=>"12345678aA!",
    "password_confirmation"=>"12345678aA!",
    "is_active"=>true,
    "confirmation_sent_at"=>Time.now,
    "exp_date"=>Time.now + 30.days
  }
  user_exist = User.where("email ='#{user_details["email"]}'")
  if !user_exist.present?
    @user = User.new(user_details)
    @user.created_at = @created_date
    @user.save
  else
    @user = User.last
    @user.created_at = @created_date
    @user.save
  end



  # Creating Questions
  #======================#
  faker_hash_feed_back = []
  faker_hash_multiple= []
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

   #create Yes No answer
  @question_count.times do
    faker_hash_yes_no << {:category_type_id  => 3, :expiration_id => "1 Day", :question => "#{Faker::Lorem.words(5).join(" ")}?" , :video_type => 1, :embed_url => "", :include_text => 0, :question_type_id => 3, :thanks_response => 'Thanks for responding!', :user_id => @user.id ,:created_at => @created_date, :updated_at =>@created_date, :status => 'Active', :expired_at => Time.now + 30.days,:slug => SecureRandom.urlsafe_base64(nil, false)}
  end

  batch = []
  faker_hash_yes_no.each do |row|
    batch << Question.new(row)
  end
  Question.import  batch

  question_list = Question.last @question_count
  #question option create
  question_list.each do |i|
    @option = ["Yes", "No"]
    @option.each do |option|
      option_hash << {:question_id=>i.id,:option=> option ,:created_at=>@created_date,:updated_at=>@created_date,:is_other=>false,:is_deactivated=>false}
    end
    @id = 0
    @id1 = 0
    @providers.each do |r|
      @month = [30,40,50,20,10,60,70,80,90,100,110,120,130,150,300,120,130,140,150,200,210,220,260,280].sample
      @created_at = @user.created_at + @month.days
      @sharing_count.times do
        @id += 1
        share_hash <<  {:provider => r , :email_address => Faker::Internet.email , :created_at => @created_date, :updated_at => @created_date}
        cookie_token_hash << { :uuid => SecureRandom.hex(10), :created_at => @created_date, :updated_at  => @created_date}
        answer_hash << {:is_business_user => false,:question_type_id => i.question_type_id, :question_option_id => (rand*2).to_i + 1 , :question_id => i.id, :provider => r , :option => @option[((rand*2).to_i + 1) -1] , :is_deactivated => false,  :created_at => @created_at, :updated_at => @created_at , :uuid => @id, :customers_info_id => @id  }       
        response_customer_info_values << {:customer_name => Faker::Lorem.words(2).join(" ") , :email => Faker::Internet.email, :age => rand.to_s[2..3], :country => @countries.sample, :gender => @gender.sample, :created_at => @created_at , :updated_at => @created_at, :cookie_token_id => @id}
        response_cookie_info << {:cookie_token_id => @id,:response_token_id => @id, :response_token_type => "ResponseCustomerInfo" , :created_at => @created_at , :updated_at => @created_at}
        question_view_logs << {:provider => r ,:question_id => i.id , :cookie_token_id => @id , :user_id => @user.id , :created_at => @created_at , :updated_at => @created_at }
        question_response_logs << {:provider => r ,:question_id => i.id , :cookie_token_id => @id , :user_id => @user.id , :created_at => @created_at , :updated_at => @created_at }
      end
      # @sharing_count-1.times do
      #   @id1 += 1
      #   question_response_logs << {:provider => r ,:question_id => i.id , :cookie_token_id => @id1 , :user_id => @user.id , :created_at => @created_at , :updated_at => @created_at }
      # end
    end
  end

  batch = []
  option_hash.each do |i|
    batch <<  QuestionOption.new(i)
  end
  QuestionOption.import  batch

  batch =[]
  share_hash.each do |i|
    batch <<  ShareQuestion.new(i)
  end
  ShareQuestion.import batch

  batch =[]
  cookie_token_hash.each do |i|
    batch <<  CookieToken.new(i)
  end
  CookieToken.import batch

  batch =[]
  answer_hash.each do |i|
    batch <<  Answer.new(i)
  end
  Answer.import batch

  batch =[]
  response_customer_info_values.each do |i|
    batch <<  ResponseCustomerInfo.new(i)
  end
  ResponseCustomerInfo.import batch

  batch =[]
  response_cookie_info.each do |i|
    batch <<  ResponseCookieInfo.new(i)
  end
  ResponseCookieInfo.import batch

  batch =[]
  question_view_logs.each do |i|
    batch <<  QuestionViewLog.new(i)
  end
  QuestionViewLog.import batch

  batch =[]
  question_response_logs.each do |i|
    batch <<  QuestionResponseLog.new(i)
  end
  QuestionResponseLog.import batch

  QuestionResponseLog.reindex(:batch_size => 100 )
  QuestionViewLog.reindex(:batch_size => 100 )
  Question.reindex(:batch_size => 10 )
  Answer.reindex(:batch_size => 100 )
  ResponseCustomerInfo.reindex(:batch_size => 100 )
end 