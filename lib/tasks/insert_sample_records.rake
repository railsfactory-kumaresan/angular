desc "Creating a sample data's"
task :insert_sample_records => [:environment] do
  @first_names = %w(Arun Johnson Sachin Ram Parthiban John Harry Sally Sita Ganapathi Vagmi)
  @last_names = %w(Gupta Mehta Jain Singh Menon Krishan)
  @domains = %w(gmail.com yahoo.com msn.com hotmail.com sify.com)
  @providers = %w(Email Twitter Linkedin Sms Facebook)
  @countries = ['IN','US','CN','UK']
  @values = ['Modi','Sonia','Rahul']
  @sports = %w(tennis footbal Throwball Volleyball Basketball Korfball Netball Baseball Cricket Kickball)
  @options = ['Modi','Sonia','Rahul']
  @gender = %w(Male Female)
  @connection = ActiveRecord::Base.connection
  @created_date = Time.now.ago(365.days)
  @answer_values = []
  @response_customer_info_values = []
  @share_values = []
  @cookie_token_values = []
  @response_cookie_info_values = []
  @question_values = []
  @question_view_log_values = []
  @question_response_log_values = []
  @view_response_keys =[]
  puts Benchmark.measure { create_user }
  puts Benchmark.measure { create_questions }
  puts Benchmark.measure { increase_view_response_count }
  #puts Benchmark.measure { index_tables }

end

def increase_view_response_count
#	RedisCount::RedisKeyIncrement.new(@view_response_keys.flatten).increment_keys
end



def index_tables
   puts "indexing QuestionResponseLog"

 QuestionResponseLog.find_in_batches do |batch|
           Sunspot.index(batch)
end
     Sunspot.commit()

puts "indexing QuestionViewLog"
 QuestionViewLog.find_in_batches do |batch|
           Sunspot.index(batch)
end
  Sunspot.commit()

puts "indexing Question"
 Question.find_in_batches do |batch|
           Sunspot.index(batch)
 end
  Sunspot.commit()

puts "indexing Answer"
 Answer.find_in_batches do |batch|
           Sunspot.index(batch)
 end
   Sunspot.commit()

puts "indexing ResponseCustomerInfo"
 ResponseCustomerInfo.find_in_batches do |batch|
           Sunspot.index(batch)
 end
    Sunspot.commit()
end

def insert_data
insert_question_sql = "INSERT INTO questions(category_type_id,expiration_id,question,video_type,embed_url,include_other,include_text,question_type_id,thanks_response,user_id,created_at,updated_at,status,expired_at) VALUES #{@question_values.join(", ")}"
@connection.execute insert_question_sql
insert_share_details_sql = "INSERT INTO share_questions(provider,email_address,created_at,updated_at) VALUES #{@share_values.join(", ")}"
@connection.execute insert_share_details_sql
insert_cookie_tokens_sql = "INSERT INTO cookie_tokens(uuid,created_at,updated_at) VALUES #{@cookie_token_values.join(", ")}"
@connection.execute insert_cookie_tokens_sql
insert_answer_details_sql = "INSERT INTO answers(is_business_user,question_type_id,question_option_id,question_id,provider,option,is_deactivated,created_at,updated_at,uuid,customers_info_id) VALUES #{@answer_values.join(", ")}"
@connection.execute insert_answer_details_sql
response_cus_info_sql = "INSERT INTO response_customer_infos(customer_name,email,age,country,gender,created_at,updated_at,cookie_token_id) VALUES #{@response_customer_info_values.join(", ")}"
@connection.execute response_cus_info_sql
response_cookie_info_sql = "INSERT INTO response_cookie_infos(cookie_token_id,response_token_id,response_token_type,created_at,updated_at) VALUES #{@response_cookie_info_values.join(", ")}"
@connection.execute response_cookie_info_sql
question_view_log_sql = "INSERT INTO question_view_logs(provider,question_id,cookie_token_id,user_id,created_at,updated_at) VALUES #{@question_view_log_values.join(", ")}"
@connection.execute question_view_log_sql
question_response_log_sql = "INSERT INTO question_response_logs(provider,question_id,cookie_token_id,user_id,created_at,updated_at) VALUES #{@question_response_log_values.join(", ")}"
@connection.execute question_response_log_sql
end


#Create user
def create_user
  user_details = {
    "first_name"=> "Arun",
    "last_name" =>"Sakthivel",
    "email"=>"nandhini@railsfactory.org",
    "company_name"=>"Rails",
    "business_type_id"=>2,
    "confirmed_at"=>Time.now,
    "password"=>"12345678",
    "password_confirmation"=>"12345678",
    "is_active"=>true,
    "confirmation_sent_at"=>Time.now,
    "exp_date"=>Time.now.ago(2.days)
  }
 #@user = User.new(user_details)
  @user = User.last
  @user.created_at = @created_date
  @user.save
  #@user = User.last
end

#Create questions
def create_questions
  @user = User.last
  number_of_questions = 1
   @id = Answer.last.id.to_i
   question_id = Question.last.id.to_i
number_of_questions.times do
  question_id +=1
 # category_type_id = 2
  @question_type_id = [1].sample
  @category_type = [1].sample

  @question_values.push "(#{@category_type},'1 Day','Who is the next PM of India?',1,'','0','0',#{@question_type_id},'Thanks for responding!',#{@user.id},'#{@created_date}','#{@created_date}','Active','#{Date.today+1.year}')"
  @options.each do |option|
    QuestionOption.create(:question_id=>question_id,:option=>option,:created_at=>Date.today+1.year,:updated_at=>Date.today+1.year,:is_other=>false,:is_deactivated=>false)
  end
  share_question(question_id,@category_type)
end

  #QuestionOption.add_question_options(@options,question.id,0,false)
  # question.update_status_with_expired_at
  #share_question(question.id,question.category_type_id)
  #@question_process_number = x
  #end
   puts Benchmark.measure { insert_data }

end

#Sharing the questions
def share_question(question_id,category_type_id)
  number_of_shares = 100000
  number_of_shares.times do
      @id += 1
      first_name = @first_names.sample
      last_name = @last_names.sample
      provider = @providers.sample
      email = first_name + "." + last_name + '@' + @domains.sample
     @share_values.push "('#{provider}','#{email}','#{@created_date}','#{@created_date}')"
      secure_cookie_token = SecureRandom.hex(10)
      @cookie_token_values.push "('#{secure_cookie_token}','#{@created_date}','#{@created_date}')"
      response_question(question_id,@id,category_type_id,provider,first_name,last_name)
      print "done with #{@id}..............processing question #{@question_id} \r"
end
#  response_question(id,uuid,category_type_id)
end

#Response the shared questions
def response_question(id,uuid,category_type_id,provider,first_name,last_name)
  option_id = (rand*2).to_i + 1
  age = (rand*50).to_i + 1
  gender = @gender.sample
  country = @countries.sample
  email = first_name + "." + last_name + '@' + @domains.sample
  month = [30,40,50,20,10,60,70,80,90,100,110,120,130,150,300,120,130,140,150,200,210,220,260,280].sample
  created_at  = @user.created_at + month.days
  @answer_values.push "(#{false},1,#{option_id},#{id},'#{provider}','#{@values[option_id -1]}',#{false},'#{created_at}','#{created_at}',#{uuid},#{uuid})"
  @response_customer_info_values.push "('#{first_name}','#{email}',#{age},'#{country}','#{gender}','#{created_at}','#{created_at}',#{uuid})"
  @response_cookie_info_values.push "(#{uuid},#{uuid},'ResponseCustomerInfo','#{created_at}','#{created_at}')"
  @question_view_log_values.push "('#{provider}','#{id}',#{uuid},#{@user.id},'#{created_at}','#{created_at}')"
  @question_response_log_values.push "('#{provider}','#{id}',#{uuid},#{@user.id},'#{created_at}','#{created_at}')"
  push_redis_keys(id,provider,@user.id,age,gender,uuid,country,created_at,category_type_id)
end

def push_redis_keys(id,provider,user_id,age,gender,uuid,country,created_at,category_type_id)
 # @view_response_keys << RedisCount::IncrementViewCount.new(id,provider,user_id,nil,nil,uuid,nil,created_at,category_type_id,created_at).increase_view_count
 # @view_response_keys << RedisCount::IncrementResponseCount.new(id,provider,user_id,nil,nil,uuid,nil,created_at,category_type_id,created_at).increase_response_count
 # @view_response_keys << RedisCount::IncrementViewCount.new(id,provider,user_id,age,gender,uuid,nil,created_at,category_type_id,created_at).increase_view_count_by_age
 # @view_response_keys << RedisCount::IncrementResponseCount.new(id,provider,user_id,age,gender,uuid,nil,created_at,category_type_id,created_at).increase_response_count_by_age
 # @view_response_keys << RedisCount::IncrementViewCount.new(id,provider,user_id,age,gender,uuid,country,created_at,category_type_id,created_at).increase_country_wise_view_count
end
