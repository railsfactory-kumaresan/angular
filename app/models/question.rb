class Question < ActiveRecord::Base
  include ActionView::Helpers::DateHelper
  extend FriendlyId
  include QuestionValidation
  include CreateQuestion
  include EmailTrack
  #~ include QuestionList
  friendly_id :slug, use: :slugged

  before_create :generate_unique_slug_key,:generate_bitly_url
  after_create :create_or_update_share_detail

  VIDEO_TYPES = {1 => "Embed Url", 2 => "Self Upload"}
  scope :fetch_question, lambda { |id| where('slug=?', id) }
  scope :find_tenent_questions, ->(tenent_ids) {where("tenant_id IN (?)", tenent_ids)}
  scope :by_country, ->(country) {where('country = ?',"#{country}")  }
  scope :by_state, ->(state) {where('state = ?',"#{state}")  }
  scope :by_city, ->(city) {where('city ILIKE ?',"#{city}")  }
  scope :by_gender, ->(gender) {where('gender ILIKE ?',"#{gender}")}
  scope :by_response_provider_name, ->(provider) {where('question_response_logs.provider = ?',"#{provider}")  }
  scope :by_view_provider_name, ->(provider) {where('question_view_logs.provider = ?',"#{provider}")  }
  scope :by_answer_provider_name, ->(provider) {where('answers.provider = ?',"#{provider}")  }
  scope :by_responded_at, ->(res_at) {where('DATE(responded_at) = ?',"#{res_at}")  }
  scope :by_tenant_name, ->(tenant_name) {where('tenants.name = ?',"#{tenant_name}") if tenant_name != "Own Questions" }
  scope :by_custom_field, ->(custom_field) {where('custom_field ILIKE ?',"#{custom_field}")  }
  scope :by_opens, ->(opens) {where('opens = ?',"#{opens}")  }
  scope :by_clicks, ->(clicks) {where('clicks = ?',"#{clicks}")  }
#  scope :fetch_users_question, lambda { |id| where('user_id=?', id) unless id.nil? }

  # handle_asynchronously :solr_index, queue: 'indexing', priority: 50

  # List questions belonging to a category and to a particular user
  # user_id - The id of user who created the question
  #   4 => Status is Active
  #   5 => Status is Closed
  #   6 => Get questions in any status
  #   any other number => Returns questions whose category_type_id is that number
  # returns Array of questions
  def self.catogory_question(user_id, category)
    if category == 4
      where('user_id =? AND status=?', user_id, 'Active')
    elsif category == 5
      where('user_id =? AND status=?', user_id, 'Closed')
    elsif category == 6
      where('user_id =?', user_id)
    else
      where('user_id =? AND category_type_id =?', user_id, category)
    end
  end

  def self.fetch_view_users(result_type, question_id, params)
    questions = where(:slug => question_id)
    customers = result_type == "view" ? questions.get_view_results(params) : questions.get_responded_results(params)
  end
  
  def self.fetch_all_view_users(result_type, user_id, params)
    tenant_questions = Question.find_tenent_questions(ExecutiveTenantMapping.get_tenant_ids(user_id))
    questions = tenant_questions.blank? ? User.find(user_id).questions : tenant_questions
    customers = result_type == "view" ? questions.get_view_results(params) : questions.get_responded_results(params)
  end
  
  def self.fetch_answerd_customers(question_id, option)
    questions = where(:slug => question_id)
    unless option.blank?
      questions.joins(:answers).joins("FULL OUTER JOIN tenants tn on questions.tenant_id = tn.id FULL OUTER JOIN business_customer_infos bc on bc.id = answers.customers_info_id").where("answers.comments is null and bc.id is not null and option = ?", option).select("row_number() OVER () AS id, bc.id AS customer_id,questions.id AS question_id, questions.user_id as user_id, tn.name as tenant_name, tn.id as tenant_id, bc.country AS country, bc.customer_name AS name, bc.email AS email, bc.mobile AS mobile, bc.age AS age, bc.state AS state, bc.city AS city, bc.area AS area, bc.gender AS gender, bc.custom_field AS custom_field,  answers.provider as provider_name, answers.created_at AT TIME ZONE 'UTC' AT  TIME ZONE 'Asia/Calcutta' AS responded_at,answers.option")
    else
      questions.joins(:answers).joins("FULL OUTER JOIN tenants tn on questions.tenant_id = tn.id FULL OUTER JOIN business_customer_infos bc on bc.id = answers.customers_info_id").where("(answers.comments is not null OR answers.free_text is not null) and bc.id is not null").select("row_number() OVER () AS id, bc.id AS customer_id,questions.id AS question_id, questions.user_id as user_id, tn.name as tenant_name, tn.id as tenant_id, bc.country AS country, bc.customer_name AS name, bc.email AS email, bc.mobile AS mobile, bc.age AS age, bc.state AS state, bc.city AS city, bc.area AS area, bc.gender AS gender, bc.custom_field AS custom_field,  answers.provider as provider_name, answers.created_at AT TIME ZONE 'UTC' AT  TIME ZONE 'Asia/Calcutta' AS responded_at,answers.option, answers.comments, answers.free_text")
    end
  end

  def self.get_view_results(params)
    result = self.joins(:question_view_logs => :business_customer_info).joins("FULL OUTER JOIN tenants on questions.tenant_id = tenants.id").where("question_view_logs.business_customer_info_id is not null")
    result = result.get_view_results_for_country(params) unless params["country"].blank?
    result.select("row_number() OVER () AS id,business_customer_infos.id AS customer_id, questions.user_id as user_id, questions.question as question,question_view_logs.cookie_token_id as cookie_token_id, questions.tenant_id as tenant_id, tenants.name as tenant_name, question_view_logs.created_at AT TIME ZONE 'UTC' AT  TIME ZONE 'Asia/Calcutta' as viewed_at, question_view_logs.question_id AS question_id,business_customer_infos.country AS country, business_customer_infos.state AS state, business_customer_infos.city AS city, business_customer_infos.area AS area, business_customer_infos.customer_name AS name, business_customer_infos.email AS email, business_customer_infos.mobile AS mobile, business_customer_infos.age AS age, business_customer_infos.gender AS gender, business_customer_infos.custom_field AS custom_field, question_view_logs.provider as provider_name")
  end
  
  def self.get_responded_results(params)
    result = self.joins(:question_response_logs => :business_customer_info).joins("FULL OUTER JOIN tenants on questions.tenant_id = tenants.id").where("question_response_logs.business_customer_info_id is not null")
    result = result.get_response_results_for_country(params) unless params["country"].blank?   
    result.select("row_number() OVER () AS id,business_customer_infos.id AS customer_id, questions.user_id as user_id, questions.question as question,question_response_logs.cookie_token_id as cookie_token_id, questions.tenant_id as tenant_id, question_response_logs.created_at AT TIME ZONE 'UTC' AT  TIME ZONE 'Asia/Calcutta' as responded_at, tenants.name as tenant_name, question_response_logs.created_at AT TIME ZONE 'UTC' AT  TIME ZONE 'Asia/Calcutta' as viewed_at, question_response_logs.question_id AS question_id,business_customer_infos.country AS country, business_customer_infos.state AS state, business_customer_infos.city AS city, business_customer_infos.area AS area, business_customer_infos.customer_name AS name, business_customer_infos.email AS email, business_customer_infos.mobile AS mobile, business_customer_infos.age AS age, business_customer_infos.gender AS gender, business_customer_infos.custom_field AS custom_field, question_response_logs.provider as provider_name")
  end
  
  def self.get_view_results_for_country(params)
    result = self.where("country = ?", params["country"])
    result = self.where("category_type_id = ?", params["category_id"]) unless params["category_id"].blank?
     if params["from_date"].present? && params["to_date"].present?
      from_date,to_date = "#{params["from_date"]} 00:00:00","#{params["to_date"]} 23:59:59"
      result = self.where("(question_view_logs.created_at BETWEEN ? AND ?) AND (questions.created_at BETWEEN ? AND ?)", from_date,to_date,from_date,to_date)
    end
    result
  end
  
  def self.get_response_results_for_country(params)
    result = self.where("country = ?", params["country"])
    result = self.where("category_type_id = ?", params["category_id"]) unless params["category_id"].blank?
     if params["from_date"].present? && params["to_date"].present?
      from_date,to_date = "#{params["from_date"]} 00:00:00","#{params["to_date"]} 23:59:59"
      result = self.where("(question_response_logs.created_at BETWEEN ? AND ?) AND (questions.created_at BETWEEN ? AND ?)", from_date,to_date,from_date,to_date)
    end
    result
  end 
  
  def self.filter_by(filter_type, filter_argument, log_type)
    if filtering_scopes.include?(filter_type)
      filter_type != :provider_name ? send("by_#{filter_type}",filter_argument) : send("by_#{log_type}_#{filter_type}",filter_argument)
    end
  end

  def self.filtering_scopes
    [:country,:state,:city,:gender,:tenant_name,:responded_at,:provider_name,:custom_field, :opens, :clicks]
  end
  
 def self.get_advanced_filter_collection(collection,email_track=nil,type=nil)
   filters = {}
   filters["countries"] = collection.map(&:country).compact.uniq
   filters["states"] = collection.map(&:state).compact.uniq
   filters["cities"] = collection.map(&:city).compact.uniq
   filters["genders"] = collection.map(&:gender).collect{|g| g.capitalize if g}.uniq
   filters["tenants"] = collection.map(&:tenant_name).compact.uniq
   if email_track
     filters["opens"] = collection.map(&:opens).compact.uniq if type == "open"
     filters["clicks"] = collection.map(&:clicks).compact.uniq if type == "click"
   else
     filters["providers"] = collection.map(&:provider_name).compact.uniq
   end
   filters["custom_field"] = collection.map(&:custom_field).compact.uniq
   return filters
 end
 
  # Returns question and question_options as array
  # in the format [question, question_options]
  # question_id - id of the question whose options must be got
  def self.get_qst_with_option(question_id)
    question = self.find_by_id(question_id)
    question_options = question.question_options.where(is_other: false).sort_by{|x| x.order}
    category_type = question.category_type_id
    return question,question_options, category_type
  end

  # Active question yearly count
  # Gets the question count array that are acive in particular year
  # question - array of question in which yearly active ones should be counted
  # returns array of numbers
  def self.active_question(question)
    year_wise_active_question = question.select { |x| x.status == "Active" }.group_by { |x| x.created_at.strftime("%Y") }
    active_question = []
    year_wise_active_question.each do |year, question|
      active_question << question.count
    end
    return active_question
  end

  # Inactive question yearly count
  # Gets the question count array that are inacive in particular years
  # question - array of question in which yearly inactive ones should be counted
  # returns array of numbers
  def self.inactive_question(question)
    year_wise_inactive_question = question.select { |x| x.status == "Inactive" }.group_by { |x| x.created_at.strftime("%Y") }
    inactive_question = []
    year_wise_inactive_question.each do |year, question|
      inactive_question << question.count
    end
    return inactive_question
  end

  # closed question yearly count
  def self.closed_question(question)
    year_wise_closed_question = question.select { |x| x.status == "Active" }.group_by { |x| x.created_at.strftime("%Y") }
    closed_question = []
    year_wise_closed_question.each do |year, question|
      closed_question << question.count
    end
    return closed_question
  end

  # Gets the list of questions which matches the following parameters
  # category_id - Question matching that particular category
  # ststus - Status of the question
  # current_user - user id whos question must be got
  # limit - The page that must got
  # per_page  number of questions per page
  # returns an array of questions
  def self.find_question_list(category_id, status, user_id, tenant_id)
    all_category = ["All Questions", "All Status"]
    collect_question_list(user_id)
    qry = "id IN (?)"
    qry += "  and status = '#{status}'"  if (!all_category.include?(status) && status != nil)
    qry += " and category_type_id = #{category_id}" if !category_id.blank?
    qry += " and tenant_id = #{tenant_id}" if (tenant_id.present? && tenant_id != nil && tenant_id != "0")
    qry += " and user_id = #{user_id}" if !tenant_id.blank? && tenant_id == "0"
    includes(:category_type).where("#{qry}", @question_list_ids.uniq).order('updated_at desc')
  end

  # Gets the url for the question
  # status - What url must be gor
  #   "sms" => to get sms url
  #   "email" => to get mail url
  #   "show" => to get display url
  #   "qr"  => to get qr code url
  # returns a url string
  def custom_url(status,cus_id,current_user_id)
   short_url = self.short_url
   case status
   when "Facebook"
     url = "#{short_url}?provider=Facebook"
   when "Twitter"
     url = self.twitter_short_url
   when "Linkedin"
     url = self.linkedin_short_url
   when "sms"
     url = self.sms_short_url
   when "email"
     url = cus_id.present? ? "#{short_url}?provider=Email&cid=#{Base64.encode64( ActiveSupport::JSON.encode(cus_id))}" : "#{short_url}?provider=Email"
   when "show"
    url = short_url
   when "qr"
     url = self.qrcode_short_url
   end
   # if status == "Facebook" || status == "Linkedin" || status =="Twitter"
   #   url = "#{short_url}?provider=#{status}"
   # elsif status =="sms"
   #    url = "#{short_url}?provider=Sms"
   #  elsif status == "email"
   #    @customer, is_business_user = Question.business_response_user_checking(email_id,current_user_id)
   #    url = @customer.present? && @customer.cookie_token_id.present? ? "#{short_url}?provider=Email&cid=#{@customer.cookie_token.uuid}" : "#{short_url}?provider=Email"
   #  elsif status == "show"
   #    url = short_url
   #  elsif status == "qr"
   #    #url = "#{Bitly_url["url"]}/share/qrcode_url?user_id=#{self.id}&provider=QR"
   #  end
    return url
  end

  def self.play_demo(question_id)
    question = (question_id =~ /[[:alpha:]]/).blank? ? where(:id => question_id).last : where(:slug => question_id).last
    question_options = QuestionOption.options_without_other(question.id)
    a = ["Inquirly Feedback Services,Please Answer The Question.", "The Question is.#{question.question}", "Following options are."]
    i = 1
    question_options.each do |option|
      a.push "To Answer #{option.option}, press #{i}."
      i = i +1
    end
    a = a.push "then press * to complete your response"
    a.join(" ")
  end

#note- don't modify any limit related code
  def self.recent_activity_questions(user, category_type_id, from_date = nil, to_date = nil, request = nil, offset = 0, limit,status)
    from_date = from_date.present? ? "#{from_date.to_date.strftime('%Y-%m-%d')} 00:00:00" : ""
    to_date = to_date.present? ? "#{to_date.to_date.strftime('%Y-%m-%d')}" : ""
    tenant_ids = ExecutiveTenantMapping.get_tenant_ids(user.id)
    total_questions = includes(:category_type).where("(user_id = ? or tenant_id in (?))",user.id,tenant_ids)
    if request == "Filter" || (category_type_id != '0' && category_type_id.present?)
      total_questions = total_questions.where("questions.created_at BETWEEN ? AND ?", from_date, to_date) unless from_date.blank?
      total_questions = total_questions.where("questions.category_type_id = ?", category_type_id) if (category_type_id.present? && category_type_id.to_i != 0)
    end
    total_questions = total_questions.select("questions.slug, questions.question,  questions.created_at,questions.id,status,category_type_id, questions.tenant_id").group("questions.id,questions.question, questions.created_at").order("questions.created_at desc")
    limit = (limit.to_i <= 0) ? 3 : limit	
    if status != 'tab_ajax' && (request != "Filter" || category_type_id == '0' || category_type_id.nil?)
      limited_questions = total_questions.collect{|q| q if q.category_type_id == 1}.compact
      count = limited_questions.length
      limited_questions = limited_questions.first(limit)
    else
      limited_questions = total_questions.limit(limit).offset(offset)
      count = total_questions.length
    end
    return total_questions,limited_questions,count
  end

  # Gets the array questions who content matches the String
  # passed to the key. the maximum size of array is 5
 def self.question_suggestion(key,category_type_id,current_user)
    #category_type_id = first.id : category_type
    keyword = key.gsub('%', '\%').gsub('_', '\_')
    questions = where("( user_id = ? or private_access is FALSE) and (question LIKE ? and category_type_id = ?)", current_user.id, "%#{keyword}%", category_type_id.to_i).order("created_at DESC").limit(5)
  end

  # Gets the array of question for API who content matches
  # the String passed to the key
  def self.api_question_suggestion(question)
    que = question.gsub('%', '\%').gsub('_', '\_')
    where("question LIKE ?", "%#{que}%").order("created_at DESC")
  end

  def self.question_status
    questions = Question.where(:status => 'Active')
    questions.each do |question|
      expire = question.expiration_id
      created_at = question.created_at
      expire_date = (expire.present? ? expire.split(" ") : '')
      if question.expired_at <= Time.now
        #qus = Question.find(question.id)
        question.status = "Closed"
        question.save(:validate => false)
      end
    end
  end

  # Passed a string to emai, it returns nil if email is valid
  # else returns a errors[:email] which contains a error
  # message
  def self.validate_email(email)
    errors = {}
    if email.present?
      unless email=~ /^[A-Za-z0-9._%+-]+@(?:[A-Za-z0-9-]{2,3}+\.){1,2}[A-Za-z]{2,4}$/i
        errors[:email]="Please enter a valid email address"
      end
    else
      errors[:email] = "Please enter an email"
    end
    errors
  end

  def self.find_activity_result(user, category_type_id, from_date, end_date)
    query = category_type_id == 0 ? " questions.category_type_id in (1,2,3) and" : (category_type_id.blank? ? "" : (category_type_id != 0 ? "questions.category_type_id = #{category_type_id} and" : "" ))
    Question.joins("LEFT OUTER JOIN answers ON question_id = questions.id").where(query + " questions.user_id = #{user.id} and (questions.created_at BETWEEN ? AND ?)", from_date.to_date.strftime("%Y-%m-%d 00:00:00"), end_date.to_date.strftime("%Y-%m-%d 23:59:59")).select("questions.question,answers.option,count(answers.option) as response_count,questions.created_at").group("answers.option, questions.question, questions.created_at").order("questions.created_at desc")
  end

   def self.find_activity_result_report(user, category_type_id, from_date, end_date)
    query = category_type_id == 0 ? " questions.category_type_id in (1,2,3) and" : (category_type_id.blank? ? "" : (category_type_id != 0 ? "questions.category_type_id = #{category_type_id} and" : "" ))
    #Question.joins("LEFT OUTER JOIN answers ON question_id = questions.id LEFT OUTER JOIN business_customer_infos ON answers.uuid = business_customer_infos.cookie_token_id LEFT OUTER JOIN response_customer_infos ON answers.uuid = response_customer_infos.cookie_token_id").where("#{query} questions.user_id = #{user.id} and (questions.created_at BETWEEN ? AND ?)", from_date.to_date.strftime("%Y-%m-%d 00:00:00"), end_date.to_date.strftime("%Y-%m-%d 23:59:59")).select("questions.question,answers.option,count(answers.option) as response_count,questions.created_at,business_customer_infos.customer_name as customer_name,business_customer_infos.mobile as mobile,business_customer_infos.email as email,business_customer_infos.country as country,business_customer_infos.age as age,business_customer_infos.gender as gender").group("answers.option, questions.question, questions.created_at,business_customer_infos.customer_name,business_customer_infos.mobile,business_customer_infos.email,gender,business_customer_infos.country,business_customer_infos.age").order("questions.created_at desc")
    #Question.joins("LEFT OUTER JOIN answers ON question_id = questions.id LEFT OUTER JOIN response_customer_infos ON answers.uuid = response_customer_infos.cookie_token_id LEFT OUTER JOIN business_customer_infos  ON answers.uuid = response_customer_infos.cookie_token_id").where("#{query} questions.user_id = #{user.id} and (questions.created_at BETWEEN ? AND ?)", from_date.to_date.strftime("%Y-%m-%d 00:00:00"), end_date.to_date.strftime("%Y-%m-%d 23:59:59")).select("questions.question,answers.option,count(answers.option) as response_count,questions.created_at,response_customer_infos.* as response_info, business_customer_infos.* as business_info").group("answers.option, questions.question, questions.created_at, response_customer_infos.id, business_customer_infos.id").order("questions.created_at desc")
    if from_date.present? && end_date.present?
       Question.joins("LEFT OUTER JOIN answers ON question_id = questions.id LEFT OUTER JOIN response_customer_infos ON answers.uuid = response_customer_infos.cookie_token_id LEFT OUTER JOIN business_customer_infos  ON answers.uuid = business_customer_infos.cookie_token_id").where(query + " questions.user_id = #{user.id} and (questions.created_at BETWEEN ? AND ?)", from_date.to_date.strftime("%Y-%m-%d 00:00:00"), end_date.to_date.strftime("%Y-%m-%d 23:59:59")).select("questions.question,answers.option,questions.question_type_id,count(answers.option) as response_count,count(answers.comments) as comment_count,questions.created_at,business_customer_infos.customer_name as customer_name,business_customer_infos.mobile as mobile,business_customer_infos.email as email,business_customer_infos.country as country,business_customer_infos.age as age,business_customer_infos.gender as gender,response_customer_infos.customer_name as customer_name1,response_customer_infos.mobile as mobile1,response_customer_infos.email as email1,response_customer_infos.country as country1,response_customer_infos.age as age1,response_customer_infos.gender as gender1").group("answers.option, questions.question,questions.question_type_id,questions.created_at,business_customer_infos.customer_name,business_customer_infos.mobile,business_customer_infos.email,business_customer_infos.gender,business_customer_infos.country,business_customer_infos.age,response_customer_infos.customer_name,response_customer_infos.mobile,response_customer_infos.email,response_customer_infos.gender,response_customer_infos.country,response_customer_infos.age").order("questions.created_at desc")
    else
      Question.joins("LEFT OUTER JOIN answers ON question_id = questions.id LEFT OUTER JOIN response_customer_infos ON answers.uuid = response_customer_infos.cookie_token_id LEFT OUTER JOIN business_customer_infos  ON answers.uuid = business_customer_infos.cookie_token_id").where(query + " questions.user_id = #{user.id}").select("questions.question,answers.option,questions.question_type_id,count(answers.option) as response_count,count(answers.comments) as comment_count,questions.created_at,business_customer_infos.customer_name as customer_name,business_customer_infos.mobile as mobile,business_customer_infos.email as email,business_customer_infos.country as country,business_customer_infos.age as age,business_customer_infos.gender as gender,response_customer_infos.customer_name as customer_name1,response_customer_infos.mobile as mobile1,response_customer_infos.email as email1,response_customer_infos.country as country1,response_customer_infos.age as age1,response_customer_infos.gender as gender1").group("answers.option, questions.question,questions.question_type_id,questions.created_at,business_customer_infos.customer_name,business_customer_infos.mobile,business_customer_infos.email,business_customer_infos.gender,business_customer_infos.country,business_customer_infos.age,response_customer_infos.customer_name,response_customer_infos.mobile,response_customer_infos.email,response_customer_infos.gender,response_customer_infos.country,response_customer_infos.age").order("questions.created_at desc")
    end

  end

  ##
  #
  def self.sum_response_count_by_option(question_array)
  count_hash = Hash.new(0)
   question_array && question_array.each do |category|
     if category.question_type_id == 4
       count_hash["#{category.question} | Comment Type"] += category.comment_count.to_i
     else
       if category.option.present?
        count_hash["#{category.question} | #{category.option}"] += category.response_count.to_i
       end
     end
      end
     return count_hash
  end

  def self.get_questions(user,start_date,end_date,category_type_id)
    category_type_id = category_type_id.to_i
    questions ={}
    if category_type_id.blank? || category_type_id == 0
      category_types = CategoryType.get_categories(user)
      category_types.each do |category|
        questions["#{category.category_name}"] = Question.find_activity_result(user,category.id,start_date,end_date)
      end
    else
      category_name = CategoryType.find_category(category_type_id)
      questions["#{category_name}"] = category_type_id.present? ? Question.find_activity_result(user,category_type_id,start_date,end_date) : []
    end
   return questions
  end

  def self.get_questions_report(user,start_date,end_date,category_type_id)
    category_type_id = category_type_id.to_i
    questions ={}
    if category_type_id.blank? || category_type_id == 0
      category_types = CategoryType.get_categories(user)
      category_types.each do |category|
        questions["#{category.category_name}"] = Question.find_activity_result_report(user,category.id,start_date,end_date)
      end
    else
      category_name = CategoryType.find_category(category_type_id).map(&:category_name).first
      questions["#{category_name}"] = category_type_id.present? ? Question.find_activity_result_report(user,category_type_id,start_date,end_date) : []
    end
   return questions
  end
  # def self.monthly_view_response(questions, months)
  #   final_val = {}
  #   months.each do |val|
  #     temp = []
  #     temp << questions.map { |dat| dat.answers_count if dat.created_at.strftime("%m-%Y") == val }.compact.sum
  #     temp << questions.map { |dat|
  #       if dat.question_view_counts.present? && dat.question_view_counts
  #         monthly_question_view = dat.question_view_counts.map { |qus_view| qus_view if qus_view.created_at.strftime("%m-%Y") == val }.compact
  #         monthly_question_view.map(&:view_count).compact.sum
  #       else
  #         0
  #       end
  #       }.sum
  #       final_val[val] = temp
  #     end
  #     return final_val
  #   end

    # Called before user is saved
    # When expiration_id_is set, the following is set to
    # expired_at
    # expiration_id => expired_at
    # "1 Day" =>  a day from today
    # "1 Week" => a month from today
    # "1 Month" => a month from today
    # "1 Year" => a year from today
    def update_status_with_expired_at
      case self.expiration_id.split(" ")[1]
      when "Week"
        expired_at = Time.now + 1.week
      when "Month"
        expired_at = Time.now + 30.days
      when "Year"
        expired_at = Time.now + 1.year
      when "Day"
        expired_at = Time.now + 1.day
      end
        self.status="Active"
        self.expired_at = expired_at
        self.save(:validate => false)
    end

  # returns true if question has expired
  # def is_expired?
  #   Time.now > self.expired_at
  # end

  # def self.wordcloud_responses(params,current_user)
  #   answers,other_response = [],[]
  #   #question_ids = current_user.questions.pluck(:id)
  #   question_ids = Question.where("slug =?",params[:type]).first
  #   @search = Answer.search do
  #     with(:question_id,question_ids.id)
  #     with(:option, params[:word])
  #     with(:current_user_question,question_ids.question)
  #     without(:customer_name,nil)
  #     facet(:attachment)
  #     facet(:customer_name)
  #     facet(:option)
  #     facet(:customer_country)
  #     facet(:current_user_question)
  #     facet(:question_created_at)
  #     facet(:customer_age)
  #     facet(:customer_email)
  #     facet(:customer_gender)
  #     facet(:customer_mobile)
  #     paginate :page => params[:page], :per_page => 6
  #   end
  #   return @search.hits
  # end
  # def self.wordcloud_responses_dashboard(params,current_user)
  #   question_ids = current_user.questions.pluck(:id)
  #   answers,other_response = [],[]
  #    @search = Answer.search do
  #     with(:option, params[:word])
  #     with(:question_id,question_ids)
  #     without(:customer_name,nil)
  #     facet(:attachment)
  #     facet(:customer_name)
  #     facet(:option)
  #     facet(:customer_country)
  #     facet(:current_user_question)
  #     facet(:question_created_at)
  #     facet(:customer_age)
  #     facet(:customer_email)
  #     facet(:customer_gender)
  #     facet(:customer_mobile)
  #     paginate :page => params[:page], :per_page => 6
  #   end
  #   return @search.hits
  # end

  #business or response user checking
  def self.business_response_user_checking(email,user_id)
    biz_user = BusinessCustomerInfo.where("email =? and user_id=? and (is_deleted is NULL OR is_deleted is TRUE)",email.downcase,user_id).first
    unless biz_user
      biz_customer = BusinessCustomerInfo.where("email =? and (is_deleted is NULL OR is_deleted is TRUE)", email.downcase).first
      if biz_customer
        dup_biz_customer = biz_customer.dup
        dup_biz_customer.user_id = user_id
        dup_biz_customer.is_deleted = nil if dup_biz_customer.is_deleted
        dup_biz_customer.save
        biz_user = dup_biz_customer
      end
    end

    if biz_user.present?
      biz_user.update_attribute('is_deleted',nil) if biz_user.is_deleted
      user_result = biz_user
      is_business_user = true
    end

    return user_result,is_business_user
  end

  # Returns array of questions whos id is equal
  # to the passed argument
  # def self.find_question(id)
  #   where(id: id)
  # end

  # Returns number of answers the question has
  def answers_count
    self.answers.where("option is not null and option <> '' ").count
  end

  def call_report_weekly_daily
    @questions = @questions.sort! { |a, b| b.answers.count <=> a.answers.count }
    @questions = @questions[0..2].each do |q|
      # Top three question
      @questions << q
      @User_details = User.find_by_id(q.user_id)
      @top_three_questions_hash << {"user_name" => (@User_details&&@User_details.first_name.present?) ? @User_details.first_name : "", "question" => q.question, "view_count" => q.question_view_counts.count, "responce_count" => q.answers.count}
    end
    # Top 3 companies which are have more responces.
    @top_companies= []
    @questions.each do |t|
      @User_details = User.find_by_id(t.user_id)
      @top_companies << {"company_name" => (@User_details && @User_details.company_name.present?) ? @User_details.company_name : "", "question" => t.question, "view_count" => t.question_view_counts.count, "responce_count" => QuestionOption.options_without_other(@question.id).count}
    end
  end

  # Gets a question by its slug
  # def self.find_question_id(question)
  #   question_id = find_by_slug(question)
  # end

  def embed_question_share
    if self.status.include?("Inactive")
      self.update_status_with_expired_at
    end
    user = User.find(self.user_id)
    ShareQuestion.create(:provider => "embed", :email_address => user.email,:user_id => user.id)
    attachment = self.attachment
    company_name = User.where(:id => self.user_id).select(:company_name)
    question_options = QuestionOption.options_without_other(self.id)
    return attachment, company_name, question_options
  end


  def question_logo
    question_logo = self.attachment.image(:thumb) if  self.attachment.present? && self.attachment.image.present? && self.attachment.image.url.present?
  end

  def qrcode_status_update
    self.qrcode_status = "Active"
    self.save(:validate => false)
    if self.status.include?("Inactive")
      self.update_status_with_expired_at
    end
  end

  # Gets the question from its id
  def self.find_question_owner(question_id)
    where("id=?",question_id).first
  end

  def self.create_new_question(params,current_user)
    errors=[]
    questions,ans_err,ans_uni_err,error_two_option,array_items=self.build_question(params,current_user,'create')
    if ans_err.nil? && ans_uni_err.empty? && error_two_option.blank? && questions.save
      QuestionOption.add_question_options(array_items, questions.id, 0, false)
      if params[:question][:include_other] && params[:question][:include_other] == '1'
        max_order = QuestionOption.find_max_option_order(questions.id)
      end
      qst_options = questions.question_options
      custom_url = self.question_url(questions.slug)
      return questions,custom_url.short_url,qst_options,""
    else
      errors << ans_uni_err.first if ans_uni_err.present?
      errors << questions.errors if questions.errors.any?
      errors << error_two_option if !error_two_option.blank?
      errors << ans_err if !ans_err.blank?
      return "","","",errors
    end
  end

  def self.build_question(params,current_user,state)
    questions,ans_err,ans_uni_err,error_two_option,array_items = build_questions(params,current_user,state)
    return questions,ans_err,ans_uni_err,error_two_option,array_items
  end


  # Returns number of days for the question to expire
  # question - Question whos dates to expire must be found out
  def self.get_question_expiration(question)
    if  question.status =='Active'
      expire_within = (question.expired_at- Time.now).to_i
    elsif  question.status =='Inactive'
      case question.expiration_id
      when '1 Day'
        expire_within = 1
      when '1 Week'
        expire_within = 7
      when '1 Month'
        expire_within = Time.days_in_month(Time.now.strftime("%m").to_i)
      when '1 Year'
        expire_within = ((Time.now + 1.year) - Time.now).to_i
      end
    else
      expire_within ="Question has been Expired"
    end
    return expire_within
  end

  def self.generate_xml(params)
    question_view_id = params['question_view_id'] if params[:question_view_id]
    question = Question.find(params['question_id']) if params[:question_id]
    answer_options = QuestionOption.where("question_id=? and is_deactivated=? and is_other=?",question.id,false,false).sort_by{|x| x.order}.map(&:option)
    call_initiate_content = params[:content].present? ? params[:content].to_s + ",Please choose the option to answer the question" : "Inquirly Feedback Services,Please choose the option to answer the question."
    if !question_view_id.present?
      business_user = BusinessCustomerInfo.where("mobile like ? and user_id = ?","%#{params["Called"].to_i}",question.user_id).last
      QuestionViewLog.create_new_record(question,"Call", business_user.id) if params[:is_demo] == "false"
      question.update_status_with_expired_at if question.status.include?("Inactive")
    end
    people = {
      '+201-383-8681' => 'Inquirly',
    }
    name = people['+91 806 888 8077'] || 'Inquirly'
     change_call_voice(params[:To].to_s.gsub("+",""))
    Twilio::TwiML::Response.new do |r|
      r.Say "#{call_initiate_content}", :voice => @voice,:language => @voice_name
      r.Say "The Question is.#{question.question}", :voice => @voice,:language => @voice_name
      r.Say "Following options are.", :voice => @voice,:language => @voice_name
     # r.Gather :Digits => '1', :timeout => "10", :finishOnKey => "*", :action => "#{Bitly_url["url"]}/share/handle_gather.xml?question_id=#{question.id}&is_demo=#{params[:is_demo]}", :method => 'get' do |g|
      r.Gather :Digits => '1',:numDigits => 1, :timeout => "10",  :action => "#{Bitly_url["url"]}/share/handle_gather.xml?question_id=#{question.id}&is_demo=#{params[:is_demo]}", :method => 'get' do |g|
        answer_options = answer_options.insert(0,0)
        for i in 1..answer_options.length-1
          g.Say "To Answer #{answer_options[i]}, press #{i}.", :voice => @voice,:language => @voice_name
        end
        #g.Say 'Press any other key to start over.', :voice => @voice,:language => @voice_name
      end
      r.Say "Sorry, I didn't get your response.Thank you good bye.", :voice => @voice,:language => @voice_name
    end.text
  end

  def self.generate_xml_ans(params)
    question = Question.find(params['question_id']) if params[:question_id]
    question_view_id = params['question_view_id'] if params[:question_view_id]
    answer_options = QuestionOption.where("question_id=? and is_deactivated=? and is_other=?",params['question_id'],false,false).sort_by{|x| x.order}.map(&:option)
    change_call_voice(params[:To].to_s.gsub("+",""))
    Twilio::TwiML::Response.new do |r|
      answer_options = answer_options.insert(0,0)
      ans_len = answer_options.length-1
      if params['Digits'].to_i > ans_len
        r.Redirect "call_handle.xml?question_id=#{question.id}&question_view_id=#{question_view_id}"
      else
        for i in 1..answer_options.length-1
          if i == params['Digits'].to_i
            r.Say "Your Answer is #{answer_options[i]}, Thank you for your answer" ,:voice => @voice ,:language => @voice_name
            phone_number = params['To']
            business_user =  BusinessCustomerInfo.where("mobile like ? and user_id = ?","%#{params["Called"].to_i}",question.user_id).last
            QuestionResponseLog.create_new_record(question,"Call",nil,business_user.id) if params[:is_demo] == "false" || params[:is_demo].blank?
            params = {:is_answered =>"false", :answer_option =>answer_options[i], :question_id => question.id, :cookie_token_id=>"", :answer_id=>"", :category_type_id =>question.category_type_id, :provider =>"Call"}
            call_responses(params,question,phone_number) if params[:is_demo] == "false" || params[:is_demo].blank?
          end
        end
      end
    end.text
  end

  def self.call_responses(params,question,phone_number)
    customer = BusinessCustomerInfo.where("mobile like ? and user_id = ?","%#{phone_number.to_i}",question.user_id).last if phone_number
    customer = customer.nil? ? "" : customer
    option = QuestionOption.where("question_id=? and option =?",question.id,params[:answer_option])[0]
    if !customer.blank?
      Answer.create_multiple_responses(0,params,option.id,nil, customer.id,customer.cookie_token_id,question.id,question.question_type_id,params[:provider],true)
    end
  end


  def self.get_email_list(current_user,biz_customer_ids,to_address,question)
    email_array = []
    current_user.share_questions.create(:provider => "Email", :email_address => current_user.email)
    to_address.each_with_index {|email,index|
      custom_url = question.custom_url("email",biz_customer_ids[index],current_user.id)
      email_share_collection = {"email" => email, "bitly_url" => custom_url}
      email_array << email_share_collection
    }
    return email_array
  end

  # Returns the Question whos id is given to the
  # argument id
  def self.find_category_type_id(id)
    where("id=?",id)[0]
  end

# def provider_wise_count(params)
#   question_id = self.id
#   if params[:category].present?
#     views = RedisCount::GetViewCount.new(question_id,nil,nil,nil,nil,nil,params[:category],params[:from_date],params[:to_date],nil).get_view_count_provider
#     responses = RedisCount::GetResponseCount.new(question_id,nil,nil,nil,nil,nil,params[:from_date],params[:to_date],params[:category],nil).get_response_count_provider
#   else
#     views = RedisCount::GetViewCount.new(question_id).get_view_count_provider
#     responses = RedisCount::GetResponseCount.new(question_id).get_response_count_provider
#   end
#   return views,responses
# end

# Gets question by it id and slug
def self.get_question(id)
  (id =~ /[[:alpha:]]/).blank? ? where(id: id).last : where(slug: id).last
end

# def self.increase_question_wise_count(params,user_id,category_type_id,uuid,question_id)
#      RedisCount::IncrementViewCount.new(question_id,params[:provider],user_id,params[:age].to_i,params[:gender],nil,nil,Time.now,category_type_id).increase_age_wise_view_count
#      RedisCount::IncrementResponseCount.new(question_id,params[:provider],user_id,params[:age].to_i,params[:gender],nil,nil,Time.now,category_type_id).increase_age_wise_response_count
#      RedisCount::IncrementViewCount.new(question_id,params[:provider],user_id,params[:age].to_i,params[:gender],uuid,params[:country],Time.now,category_type_id).increase_country_wise_view_count
# end

# def self.increase_count(age,gender,country,params,user_id,category_type_id,uuid,question_id)
#      RedisCount::IncrementViewCount.new(question_id,params[:provider],user_id,age.to_i,gender,nil,nil,Time.now,category_type_id).increase_age_wise_view_count
#      RedisCount::IncrementResponseCount.new(question_id,params[:provider],user_id,age.to_i,gender,nil,nil,Time.now,category_type_id).increase_age_wise_response_count
#      RedisCount::IncrementViewCount.new(question_id,params[:provider],user_id,age.to_i,gender,uuid,country,Time.now,category_type_id).increase_country_wise_view_count
# end

  # Gets the question  created by the user in a month
  # the id of the user is passed to user_id
  def self.get_monthly_count(user_id)
    from_date = Time.now.beginning_of_month.strftime("%Y-%m-%d")
    to_date =  Time.now.end_of_month.strftime("%Y-%m-%d")
    # search = Question.search do
    # with(:user_id,user_id)
    # with(:created_at, "#{ from_date } 00:00:00".."#{ to_date } 23:59:59")
    # end
    questions = select("count(*) as total_count ").where("user_id IN (?) and created_at >= ? and created_at <= ?", user_id,"#{ from_date } 00:00:00","#{ to_date } 23:59:59")
    questions.blank? ? 0 : questions[0].total_count
  end

  #   def self.recent_activity_count(user, category_type_id, from_date = nil, to_date = nil)
  #   from_date = from_date.present? ? from_date.to_date.strftime("%Y-%m-%d") : ''
  #   to_date = to_date.present? ? to_date.to_date.strftime("%Y-%m-%d") : ''
  #   result = Question.search do
  #     with(:user_id, user.id)
  #     with(:category_type_id, category_type_id)
  #     with(:created_at,"#{from_date}T00:00:00Z".."#{to_date}T23:59:59Z") unless from_date.blank?
  #   end
  #   return result.total
  # end

  # Returns the status of Question
  def check_status
   self.status
  end

 def find_expiration_time
  if self.status.include?("Inactive")
    expiration = self.inactive_question_expire
    return expiration == 1 ? "#{expiration} Day" : "#{expiration} Days"
  else
  expiration = self.inactive_question_expire
  expiration_text = distance_of_time_in_words(expiration) rescue "12 months"
  if !expiration_text.match(/minute/).nil?
   valid_time =  "1 hour"
  elsif !expiration_text.match(/months/).nil?
   valid_time = "#{self.question_expire_status} Days"
  else
   valid_time =  distance_of_time_in_words(expiration).gsub('less than','').gsub('about','')
  end
   return valid_time
 end
 end

 def find_remaining_days
    if self.present? && !self.expired_at.nil?
      case self.expiration_id
       when "1 Day"
         total_day= 1
       when "1 Week"
         total_day= 7
       when "1 Month"
         activated_date = self.expired_at.to_date - 1.month
         total_day= (self.expired_at.to_date - activated_date).to_i
       when "1 Year"
         activated_date = self.expired_at.to_date - 1.year
         total_day= (self.expired_at.to_date - activated_date).to_i
       end
     end
    remaining_days = self.question_expire_status
    if remaining_days >= 362 and remaining_days != 365
     return 96
    elsif remaining_days <= 1
     expiration = self.inactive_question_expire
     return ((expiration/1.hour)/(total_day * 24)) * 100
    else
     return (remaining_days.to_f / total_day.to_f) * 100
    end
  end


  def inactive_question_expire
    if self.expired_at.nil?
      expire = self.expiration_id
      expire_date = (expire.present? ? expire.split(" ") : '')
      expire_date[1] = expire_date[1].downcase
      self.get_number_of_days(expire_date[1])
    else
      expire_date = self.expired_at
      if expire_date < Time.now
        return 0
      else
        return (expire_date - Time.now)
      end
    end
  end


def question_expire_status
    if self.expired_at.nil?
      expire = self.expiration_id
      expire_date = (expire.present? ? expire.split(" ") : '')
      expire_date[1] = expire_date[1].downcase
      self.get_number_of_days(expire_date[1])
    else
      expire_date = self.expired_at.to_date
      if expire_date < Date.today#DateTime.now
        return 0
      else
        return (expire_date - Date.today).to_i
      end
    end
  end

  def get_number_of_days(expiration_id)
     case expiration_id
        when "day"
          return 1
        when "week"
          return 7
        when "month"
          return 30
        when "year"
          return 365
      end
    end

  def self.update_inactive_status(question,phone_number,content)
    question.status.include?("Inactive") ? question.update_status_with_expired_at : ''
    ShareDetail.update_share_count(question.user,phone_number.count,'call_count')
    Delayed::Job.enqueue(VoiceJob.new(phone_number, question.id,content,"false"), 0)
  end

  # Latest Question style  and image logo Apply for newly created question
def question_latest_style_apply(current_user,question)
  if question.present? && question.question_style.present?
    question_style = question.question_style
    self.create_question_style(:background => question_style.background, :page_header => question_style.page_header, :submit_button => question_style.submit_button, :question_text => question_style.question_text, :button_text => question_style.button_text,:answers => question_style.answers, :font_style => question_style.font_style )
  end
  if current_user.check_action_privilege('video_photo_count')
  if question.present? &&  question.attachment.present?
    self.create_attachment(:image=> URI.parse(question.attachment.image(:thumb)))
#    ShareDetail.update_share_count(current_user,1,'video_photo_count')
  elsif current_user && current_user.attachment.present?
    self.create_attachment(:image=> URI.parse(current_user.attachment.image(:thumb)))
   # ShareDetail.update_share_count(current_user,1,'video_photo_count')
  end
end
end

def question_short_url
 self.short_url
end


  def self.array_items_split(array_items)
    count = [];
    array_items && array_items.each { |e| num=0; num=array_items.length-(array_items-[e]).length; count.push([e, num]) }
    return count
  end

def self.get_date_time(created_time)
 created_time.in_time_zone(TZInfo::Timezone.get('Asia/Kolkata'))
end

  def self.delete_item_from_hash(total_view_count,total_response_count,yaxis)
    total_view_count.compact.each_with_index do |x, i|
      if total_view_count[i]== 0 && total_response_count[i] == 0
        total_view_count.delete_at(i)
        total_response_count.delete_at(i)
        yaxis.delete_at(i)
      end
    end
  end

  def self.active_qrcode_url(user_id,question)
    active_question = Question.where(qrcode_status: "Active", user_id: user_id).last
    qr_code_url = active_question.present? ? active_question.qrcode_short_url : question.qrcode_short_url
    return qr_code_url
  end

 def check_make_call_visibility
  ((self.question_type_id ==1 || self.question_type_id == 3) && !Language.get_default_language.index(self.language).nil? && !self.video_url.present? && !self.embed_url.present?) ? true : false
 end

def share_count_update(params)
video_photo_count = 0
if (self.embed_url.blank? && !params[:question][:embed_url].blank?) || (self.video_url.blank? && !params[:question][:video_url].blank?)
 video_photo_count += 1
elsif (!self.embed_url.blank? && params[:question][:embed_url].blank?) || (!self.video_url.blank? && params[:question][:video_url].blank?)
 video_photo_count += -1
end
 ShareDetail.update_share_count(self.user,video_photo_count,'video_photo_count')
end

  def self.get_question_ids(obj,params)
    from_date = params[:from_date].present? ? params[:from_date] : obj.created_at
    to_date = params[:to_date].present? ? params[:to_date] : Time.now.to_date
    category_id = params[:category_id] ? params[:category_id] : params[:category]
    tenant_ids = ExecutiveTenantMapping.get_tenant_ids(obj.id)
    if category_id.to_i != 0
      questions = where("(user_id = ? or tenant_id in (?)) and DATE(created_at) >= ? AND DATE(created_at)  <= ? AND category_type_id = ?",obj.id,tenant_ids,from_date,to_date,category_id)
    else
      questions = where("(user_id = ? or tenant_id in (?)) and DATE(created_at) >= ? AND DATE(created_at) <= ?",obj.id,tenant_ids,from_date,to_date)
    end
    question_ids = questions.map(&:id) if questions.present?
    return questions,question_ids
  end

  def self.collect_question_list(user_id)
     #Multitenant Changes
     tenant_ids = ExecutiveTenantMapping.get_tenant_ids(user_id)
     @question_list_ids = where(user_id: user_id).map(&:id) + where(tenant_id: tenant_ids).map(&:id)
  end


  def self.change_call_voice(numb)
    ph_country =  numb[0,2]
    if(ph_country == "91")
       @voice = ENV["VOICE_IND"]
       @voice_name = ENV["VOICE_IND_NAME"]
    else
      @voice = ENV["VOICE_OTH"]
      @voice_name = ENV["VOICE_OTH_NAME"]
    end
  end

  protected

  # callback for slug unique key generation
  def generate_unique_slug_key
    self.slug = loop do
      random_generate_id = SecureRandom.hex
      break random_generate_id unless self.class.exists?(slug: random_generate_id)
    end
  end

  def generate_bitly_url
    url = Question.question_long_url(slug)
    self.short_url = Question.question_url(self.slug).short_url
    self.twitter_short_url = Question.shorten_url("#{url}?provider=Twitter").short_url
    self.linkedin_short_url = Question.shorten_url("#{url}?provider=Linkedin").short_url
    self.sms_short_url = Question.shorten_url("#{url}?provider=Sms").short_url
    self.qrcode_short_url = uniq_qr_code
  end

  def self.question_url(slug)
    url = Question.question_long_url(slug)
    Question.shorten_url(url)
  end

  def uniq_qr_code
    first_question = Question.where(user_id: self.user_id).first
    if first_question.present?
      qr_code_url = first_question.qrcode_short_url
    else
      qr_code_url = Question.shorten_url("#{Bitly_url["url"]}/share/qrcode_url?user_id=#{self.user_id}&provider=QR").short_url
    end
    return qr_code_url
  end

  def self.question_long_url(slug)
   return "#{Bitly_url["url"]}/surveys/#{slug}"
  end

  def self.shorten_url(url)
    @bitly = Bitly.client
    @custom_url = @bitly.shorten(url)
  end

def create_or_update_share_detail #after create
   ShareDetail.update_share_count(self.user,1,'questions_count')
   self.update_video_count
end

def update_video_count
   video_photo_count = 0
   video_photo_count += 1  unless self.attachment.blank?
   video_photo_count += 1  if (!self.embed_url.blank? || !self.video_url.blank?)
   ShareDetail.update_share_count(self.user,video_photo_count,'video_photo_count') if video_photo_count != 0
end


def self.update_embed_status(id, user_id)
  question = where(user_id: user_id, embed_status: true)
  question.each  { |q| q.update_attribute("embed_status", false)}
  embed_question = where(id: id, user_id: user_id).first
  embed_question.update_attribute("embed_status", true)
end

def self.change_embed_status(user_id)
  question = where(user_id: user_id, status: "Active").order("created_at DESC").first
  question.update_attribute("embed_status", true) unless question.embed_status
  return question
end

end
