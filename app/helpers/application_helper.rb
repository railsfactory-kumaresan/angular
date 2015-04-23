module ApplicationHelper
  require "flash_cookie_session"
  require 'cgi'

    def check_role_level_permissions_js(controller,action)
      params[:controller] =  controller
      params[:action] = action
  session[:user_permissions] = Permission.define_permissions(current_user) if current_user && current_user.role && session[:user_permissions].blank?
  if current_user && current_user.role && !Permission.check_user_role_permissions(params[:controller],params[:action],current_user,session[:user_permissions])
  # if request.content_type =~ /json/
       #render json: {error: "#{APP_MSG['authorization']['failure']}", status: 200}
    #   flash[]
   #else
      # begin
        #redirect_to :back, :flash => { :notice => "#{APP_MSG['authorization']['failure']}" }
      # rescue ActionController::RedirectBackError
       # redirect_to "/", :flash => { :notice => "#{APP_MSG['authorization']['failure']}" }
     #  end
    #end
    return false
   else
    return true
   end 
  end


  def account_subscription(current_user)
    #~ if (current_user.business_type_id == 1)
      #~ html = <<-HTML
   #~ <a href="#{upgrade_account_index_path}" , class="button medium orange">Upgrade</a>
#~ HTML
      #~ html.html_safe
    #~ elsif (current_user.business_type_id == 2)
        #~ html = <<-HTML
   #~ <a href="#{upgrade_account_index_path}" , class="button medium orange">Upgrade</a>
   #~ <a href="#{downgrade_account_index_path}" , class="button medium orange">Downgrade</a>
#~ HTML
      #~ html.html_safe
    #~ else
    #~ html = <<-HTML
   #~ <a href="#{downgrade_account_index_path}" , class="button medium orange">Downgrade</a>
#~ HTML
      #~ html.html_safe
    #~ end
  end

  def qustion_created(created_at)
    created_at.present? ? created_at.to_date.strftime("%b %d, %Y") : ''
  end

  #~ def question_category(category, category_type_id)
    #~ result = category.map{|r| ((r.include?(category_type_id) == true) ?  r[0] : '')}
    #~ result.delete("")
    #~ return result[0]
  #~ end

  # def view_count(id)
  #   params[:category] = params[:category] || params[:category_id]
  #   if params[:category].present?
  #     @view = RedisCount::GetViewCount.new(id,nil,nil,nil,nil,nil,params[:category],params[:from_date],params[:to_date]).question_view_count
  #   else
  #     @view = RedisCount::GetViewCount.new(id,nil,nil,nil,nil,nil,nil,nil,nil).question_view_count
  #   end
  # end

  # def total_view_count(id, from_date, to_date, category)
  #   @total_view = RedisCount::GetViewCount.new(nil,nil,id,nil,nil,nil,category,from_date,to_date,nil).get_total_view_count
  # end

  # def total_response_count(id, from_date, to_date, category)
  #   @total_response = RedisCount::GetResponseCount.new(nil,nil,id,nil,nil,nil,from_date,to_date,category,nil).get_total_response_count
  # end

  # def question_response_count(id)
  #   params[:category] = params[:category] || params[:category_id]
  #   if params[:category].present?
  #     @view = RedisCount::GetResponseCount.new(id,nil,nil,nil,nil,nil,params[:from_date],params[:to_date],params[:category]).question_response_count
  #   else
  #     @view = RedisCount::GetResponseCount.new(id,nil,nil,nil,nil,nil,nil,nil,nil).question_response_count
  #   end

  # end

  # def question_type(category_type_id)
  #   case category_type_id
  #   when 1
  #     return "Feedback"
  #   when 2
  #     return "Innovation"
  #   when 3
  #     return "Marketing"
  #   end
  # end

  def countries
    countries = Country.all
  end

  def find_country(country)
    c = Country.find_by_alpha2(country) if country.present?
    country = c[1]["name"] if c.present? && c[1].present? && c[1]["name"].present?
    return country
  end

  def question_expire(expire, expired_at)
    expire_date = (expire.present? ? expire.split(" ") : '')
    date = expired_at.to_date
    remaining_day = date - DateTime.now
    return ((remaining_day.to_i ) < 0 ? 0 : (remaining_day.to_i ))
    # case expire_date[1]
    # when "Day"
    #   date = expired_at.to_date
    #   remaining_day = date - DateTime.now
    #   return ((remaining_day.to_i ) < 0 ? 0 : (remaining_day.to_i ))
    # when "Week"
    #   date = expired_at.to_date
    #   remaining_day = date - DateTime.now
    #   return ((remaining_day.to_i ) < 0 ? 0 : (remaining_day.to_i ))
    # when "Month"
    #   date = expired_at.to_date
    #   remaining_day = date - DateTime.now
    #   return ((remaining_day.to_i ) < 0 ? 0 : (remaining_day.to_i ))
    # when "Year"
    #   date = expired_at.to_date
    #   remaining_day = date - DateTime.now
    #   return ((remaining_day.to_i ) < 0 ? 0 : (remaining_day.to_i ))
    # end
  end

  def find_date_response_count(answers)
    uuids = []
    uuids = answers.collect{|answer| answer.uuid}
    uuids.uniq.length
  end

  # def copy_url(question_id)
  #   @bitly = Bitly.client
  #   url = "#{Bitly_url["url"]}/surveys/#{question_id}?provider=Email"
  #   return  @bitly.shorten(url).short_url
  # end

  # def embed_url(question_id)
  #   @bitly = Bitly.client
  #   url = "#{Bitly_url["url"]}/surveys/#{question_id}?provider=embed"
  #   return  @bitly.shorten(url).short_url
  # end

  # def get_total_unknown_view_count(known_count,total)
  #   #total = RedisCount::GetViewCount.new(nil,nil,current_user.id,nil,nil,nil,params[:category],params[:from_date],params[:to_date]).get_total_view_count
  #   calculate_unknown_count(total,known_count)
  # end

  # def get_total_unknown_response_count(known_count,total)
  #   total = RedisCount::GetResponseCount.new(nil,nil,current_user.id,nil,nil,nil,params[:from_date],params[:to_date],params[:category]).get_total_response_count
  #   calculate_unknown_count(total,known_count)
  # end

  # def get_total_unknown_view_count_report(known_count,params)
  #      total = RedisCount::GetViewCount.new(nil,nil,current_user.id,nil,nil,nil,params[:category],params[:from_date],params[:to_date]).get_total_view_count
  #      calculate_unknown_count(total,known_count)
  # end

  # def get_total_unknown_response_count_report(known_count,params)
  #   total = RedisCount::GetResponseCount.new(nil,nil,current_user.id,nil,nil,nil,params[:from_date],params[:to_date],params[:category]).get_total_response_count
  #   calculate_unknown_count(total,known_count)
  # end

  def calculate_unknown_count(total,known_count)
    total =  total ? total.to_i : 0
    known_count = known_count ? known_count.to_i : 0
    unknown = total - known_count
  end

  # def get_unknown_view_count(known_count,question_id)
  #   total = RedisCount::GetViewCount.new(question_id,nil,current_user.id,nil,nil,nil,params[:category],params[:from_date],params[:to_date]).question_view_count
  #   calculate_unknown_count(total,known_count)
  # end

  # def get_unknown_response_count(known_count,question_id)
  #   total = RedisCount::GetResponseCount.new(question_id,nil,current_user.id,nil,nil,nil,params[:from_date],params[:to_date],params[:category]).question_response_count
  #   calculate_unknown_count(total,known_count)
  # end

  def country_load_all
    [["Andorra", "AD"], ["United Arab Emirates", "AE"], ["Afghanistan", "AF"], ["Antigua and Barbuda", "AG"], ["Anguilla", "AI"], ["Albania", "AL"], ["Armenia", "AM"], ["Netherlands Antilles", "AN"], ["Angola", "AO"], ["Antarctica", "AQ"], ["Argentina", "AR"], ["American Samoa", "AS"], ["Austria", "AT"], ["Australia", "AU"], ["Aruba", "AW"], ["Aland Islands", "AX"], ["Azerbaijan", "AZ"], ["Bosnia and Herzegovina", "BA"], ["Barbados", "BB"], ["Bangladesh", "BD"], ["Belgium", "BE"], ["Burkina Faso", "BF"], ["Bulgaria", "BG"], ["Bahrain", "BH"], ["Burundi", "BI"], ["Benin", "BJ"], ["Saint Barthelemy", "BL"], ["Bermuda", "BM"], ["Brunei Darussalam", "BN"], ["Bolivia", "BO"], ["Brazil", "BR"], ["Bahamas", "BS"], ["Bhutan", "BT"], ["Bouvet Island", "BV"], ["Botswana", "BW"], ["Belarus", "BY"], ["Belize", "BZ"], ["Canada", "CA"], ["Cocos (Keeling) Islands", "CC"], ["Congo, The Democratic Republic Of The", "CD"], ["Central African Republic", "CF"], ["Congo", "CG"], ["Switzerland", "CH"], ["Cote DIvoire", "CI"], ["Cook Islands", "CK"], ["Chile", "CL"], ["Cameroon", "CM"], ["China", "CN"], ["Colombia", "CO"], ["Costa Rica", "CR"], ["Cuba", "CU"], ["Cape Verde", "CV"], ["Christmas Island", "CX"], ["Cyprus", "CY"], ["Czech Republic", "CZ"], ["Germany", "DE"], ["Djibouti", "DJ"], ["Denmark", "DK"], ["Dominica", "DM"], ["Dominican Republic", "DO"], ["Algeria", "DZ"], ["Ecuador", "EC"], ["Estonia", "EE"], ["Egypt", "EG"], ["Western Sahara", "EH"], ["Eritrea", "ER"], ["Spain", "ES"], ["Ethiopia", "ET"], ["Finland", "FI"], ["Fiji", "FJ"], ["Falkland Islands (Malvinas)", "FK"], ["Micronesia, Federated States Of", "FM"], ["Faroe Islands", "FO"], ["France", "FR"], ["Gabon", "GA"], ["United Kingdom", "GB"], ["Grenada", "GD"], ["Georgia", "GE"], ["French Guiana", "GF"], ["Guernsey", "GG"], ["Ghana", "GH"], ["Gibraltar", "GI"], ["Greenland", "GL"], ["Gambia", "GM"], ["Guinea", "GN"], ["Guadeloupe", "GP"], ["Equatorial Guinea", "GQ"], ["Greece", "GR"], ["South Georgia and the South Sandwich Islands", "GS"], ["Guatemala", "GT"], ["Guam", "GU"], ["Guinea-Bissau", "GW"], ["Guyana", "GY"], ["Hong Kong", "HK"], ["Heard and McDonald Islands", "HM"], ["Honduras", "HN"], ["Croatia", "HR"], ["Haiti", "HT"], ["Hungary", "HU"], ["Indonesia", "ID"], ["Ireland", "IE"], ["Israel", "IL"], ["Isle of Man", "IM"], ["India", "IN"], ["British Indian Ocean Territory", "IO"], ["Iraq", "IQ"], ["Iran, Islamic Republic Of", "IR"], ["Iceland", "IS"], ["Italy", "IT"], ["Jersey", "JE"], ["Jamaica", "JM"], ["Jordan", "JO"], ["Japan", "JP"], ["Kenya", "KE"], ["Kyrgyzstan", "KG"], ["Cambodia", "KH"], ["Kiribati", "KI"], ["Comoros", "KM"], ["Saint Kitts And Nevis", "KN"], ["Korea, Democratic Peoples Republic Of", "KP"], ["Korea, Republic of", "KR"], ["Kuwait", "KW"], ["Cayman Islands", "KY"], ["Kazakhstan", "KZ"], ["Lao Peoples Democratic Republic", "LA"], ["Lebanon", "LB"], ["Saint Lucia", "LC"], ["Liechtenstein", "LI"], ["Sri Lanka", "LK"], ["Liberia", "LR"], ["Lesotho", "LS"], ["Lithuania", "LT"], ["Luxembourg", "LU"], ["Latvia", "LV"], ["Libya", "LY"], ["Morocco", "MA"], ["Monaco", "MC"], ["Moldova, Republic of", "MD"], ["Montenegro", "ME"], ["Saint Martin", "MF"], ["Madagascar", "MG"], ["Marshall Islands", "MH"], ["Macedonia, the Former Yugoslav Republic Of", "MK"], ["Mali", "ML"], ["Myanmar", "MM"], ["Mongolia", "MN"], ["Macao", "MO"], ["Northern Mariana Islands", "MP"], ["Martinique", "MQ"], ["Mauritania", "MR"], ["Montserrat", "MS"], ["Malta", "MT"], ["Mauritius", "MU"], ["Maldives", "MV"], ["Malawi", "MW"], ["Mexico", "MX"], ["Malaysia", "MY"], ["Mozambique", "MZ"], ["Namibia", "NA"], ["New Caledonia", "NC"], ["Niger", "NE"], ["Norfolk Island", "NF"], ["Nigeria", "NG"], ["Nicaragua", "NI"], ["Netherlands", "NL"], ["Norway", "NO"], ["Nepal", "NP"], ["Nauru", "NR"], ["Niue", "NU"], ["New Zealand", "NZ"], ["Oman", "OM"], ["Panama", "PA"], ["Peru", "PE"], ["French Polynesia", "PF"], ["Papua New Guinea", "PG"], ["Philippines", "PH"], ["Pakistan", "PK"], ["Poland", "PL"], ["Saint Pierre And Miquelon", "PM"], ["Pitcairn", "PN"], ["Puerto Rico", "PR"], ["Palestinian Territory, Occupied", "PS"], ["Portugal", "PT"], ["Palau", "PW"], ["Paraguay", "PY"], ["Qatar", "QA"], ["Reunion", "RE"], ["Romania", "RO"], ["Serbia", "RS"], ["Russian Federation", "RU"], ["Rwanda", "RW"], ["Saudi Arabia", "SA"], ["Solomon Islands", "SB"], ["Seychelles", "SC"], ["Sudan", "SD"], ["Sweden", "SE"], ["Singapore", "SG"], ["Saint Helena", "SH"], ["Slovenia", "SI"], ["Svalbard And Jan Mayen", "SJ"], ["Slovakia", "SK"], ["Sierra Leone", "SL"], ["San Marino", "SM"], ["Senegal", "SN"], ["Somalia", "SO"], ["Suriname", "SR"], ["South Sudan", "SS"], ["Sao Tome and Principe", "ST"], ["El Salvador", "SV"], ["Syrian Arab Republic", "SY"], ["Swaziland", "SZ"], ["Turks and Caicos Islands", "TC"], ["Chad", "TD"], ["French Southern Territories", "TF"], ["Togo", "TG"], ["Thailand", "TH"], ["Tajikistan", "TJ"], ["Tokelau", "TK"], ["Timor-Leste", "TL"], ["Turkmenistan", "TM"], ["Tunisia", "TN"], ["Tonga", "TO"], ["Turkey", "TR"], ["Trinidad and Tobago", "TT"], ["Tuvalu", "TV"], ["Taiwan, Republic Of China", "TW"], ["Tanzania, United Republic of", "TZ"], ["Ukraine", "UA"], ["Uganda", "UG"], ["United States Minor Outlying Islands", "UM"], ["United States", "US"], ["Uruguay", "UY"], ["Uzbekistan", "UZ"], ["Holy See (Vatican City State)", "VA"], ["Saint Vincent And The Grenedines", "VC"], ["Venezuela, Bolivarian Republic of", "VE"], ["Virgin Islands, British", "VG"], ["Virgin Islands, U.S.", "VI"], ["Viet Nam", "VN"], ["Vanuatu", "VU"], ["Wallis and Futuna", "WF"], ["Samoa", "WS"], ["Yemen", "YE"], ["Mayotte", "YT"], ["South Africa", "ZA"], ["Zambia", "ZM"], ["Zimbabwe", "ZW"]]
  end

  def enable_listen_menu(email)
    if email == "anjan@inquirly.com"
      u_name = "anjan"
    elsif email == "manimaransudha@gmail.com"
      u_name = "sudha"
    elsif email == "amarkanand@yahoo.com"
      u_name = "amar"
    end
    return u_name
  end

  # Image file format checking for preview page, share page and response page
  def image_file_format_check(url)
    accepted_formats = [".png",".jpg",".jpeg", ".PNG", ".JPG", ".JPEG"]
    return accepted_formats.include?File.extname(url).split("?")[0] unless url.nil?
  end

  def wicked_pdf_image_tag_for_public(img, options={})
    if img[0] == "/"
      new_image = img.slice(1..-1)
      image_tag "file://#{Rails.root.join('public', new_image)}", options
    else
      image_tag "file://#{Rails.root.join('public', 'images', img)}", options
    end
  end
  def wicked_pdf_image_tag(img, options={})
   image_tag img
  end

  def qr_code(data, size=300)
    "https://chart.googleapis.com/chart?cht=qr&chs=#{size}x#{size}&chl=#{data}"
  end

  def facebook_sharing_url
    if params[:id] && params[:action] == "show" && params[:controller] == "surveys"
     @question = Question.where(slug: params[:id]).last
     @attachment1=@question.attachment if @question
     @attachment = @attachment1.present? ? @attachment1.image : "#{Bitly_url['url']}/images/default_ques.jpeg"
     @custom_url =  @question.custom_url("Facebook",nil,nil) if @question
      @company_name = User.where(id: @question.user_id).first.try(:company_name) if @question
    end
  end

  def qr_code_active_url(question)
    Question.active_qrcode_url(current_user.id,question)
  end

  def qr_code_active_question
    active_question = Question.where(qrcode_status: "Active", user_id: current_user.id).last
    active_question.present? ? active_question.id : ""
  end

  def embed_active_question
    active_question = Question.where(embed_status: true, user_id: current_user.id).last
    active_question.present? ? active_question.id : ""
  end

  #get the lowest value plan
  def low_value_plan
    PricingPlan.order_by_amount.last
  end

  #get the highest value plan
  def high_value_plan
    PricingPlan.order_by_amount.first
  end

  #Feature fetch from column_settings yml file
  def feature_column_list
    colums = COLUMN_NAME["column_settings"]
   return colums.except("business_type_id","amount")
  end

  # Changes for Pricing Plan
  def feature_column_list_new
    colums = COLUMN_NAME["column_resetting"]
    return colums
  end

 #Get plan name for payment tansaction history
 def get_plan_name(plan_id)
   plan_id ? PricingPlan.find_by_business_type_id(plan_id).plan_name : ''
 end

  def assign_parent_id
    return current_user.parent_id == 0 ? current_user.id : current_user.parent_id
  end
  
  def get_transaction_detail(order_id)
    !order_id.blank?? TransactionDetail.find_by_order_id("#{order_id}") : " "
  end

  def get_tenant_count(user)
    ClientSetting.get_column_value("tenant_count", (user.parent_id != 0 && user.parent_id != nil) ? User.where(id: user.parent_id).first : user)
  end
  
  #country array build for ccavenue
  def billing_info_country
    country = []
    Country.all.each  do |c|
      country << c[0]
    end
    return country
  end

  def valid_email?(email)
    #Need to customize this helper method.
    reg = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
    return (reg.match(email)) ? true : false
  end

  def user_plan_billinginfo(current_user)
      billing_info_detail = current_user.billing_info_detail
      pricing_plan = PricingPlan.find_pricing_plan(current_user.business_type_id).first
      pricing_plan_name = pricing_plan ? pricing_plan.plan_name : ""
      return billing_info_detail, pricing_plan_name
  end

  def check_pricing_plan_access(current_user)
    pricing_plan = PricingPlan.find_pricing_plan(current_user.business_type_id).first
    @from_number =  !pricing_plan.blank? ? pricing_plan.from_number : ""
    @redirect_url =  !pricing_plan.blank? ? pricing_plan.redirect_url : ""
  end

  def user_redirect_url
    params[:id] = params[:id].present?? params[:id] :params[:question_id]
    question = Question.where(slug: params[:id]).first
    question = Question.where(id: params[:id]).first if question.blank?
    current_users = User.where(id:question.user_id).first
    return current_users.redirect_url.blank?? ENV["DEFAULT_REDIRECT_URL"] : current_users.redirect_url if current_users.parent_id == 0 || current_users.parent_id.blank?
    tenant = Tenant.where(id:current_users.tenant_id).first if current_users.parent_id != 0
    return tenant.redirect_url.blank?? ENV["DEFAULT_REDIRECT_URL"] : tenant.redirect_url if current_users.parent_id != 0
  end

  def check_listener_permisson
    permission = Permission.define_permissions(current_user) if current_user && current_user.role
    return permission.blank? || permission["admin/listeners"].blank? ? false : permission["admin/listeners"]["index"]
  end

  def default_url_phone_user
    c = current_user.parent_id == 0 || current_user.parent_id.blank? ? current_user :  User.where(id:current_user.parent_id).first
      @default_url = c.redirect_url.blank? ? ENV["DEFAULT_REDIRECT_URL"] : c.redirect_url if current_user.parent_id.to_i == 0 || current_user.parent_id.blank?
      tenant = Tenant.where(id:current_user.tenant_id).first if current_user.parent_id.to_i > 0
      @default_url = tenant.redirect_url.blank? ? (c.redirect_url.blank? ? ENV["DEFAULT_REDIRECT_URL"] : c.redirect_url) : tenant.redirect_url if current_user.parent_id.to_i > 0
      @default_no = tenant.from_number.blank? ? (c.from_number.blank? ? ENV["DEFAULT_REDIRECT_URL"] : c.from_number) : tenant.from_number if current_user.parent_id.to_i > 0
      @default_no = c.from_number.blank? ? ENV["CALL_NUM"] :c.from_number if current_user.parent_id.to_i == 0
  end

  def check_customer_info
    biz_cus_info = BusinessCustomerInfo.where(user_id: current_user.id, is_deleted: nil).count
    return biz_cus_info == 0 ? false : true
  end

  def geo_location
    ip = request.remote_ip
    @info = GeoIP.new(Rails.root.join("db/GeoLiteCity.dat")).city(ip)
  end
end
