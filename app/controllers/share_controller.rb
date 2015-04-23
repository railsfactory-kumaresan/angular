require "#{Rails.root}/lib/mailer_job.rb"
require "#{Rails.root}/lib/voice_job.rb"
require 'open-uri'
require 'RMagick'
require 'will_paginate/array'
class ShareController < PrivilegeController
  protect_from_forgery :except => [:call_handle, :handle_gather]
  before_filter :authenticate_user_web_api, :except => [:embed, :user_info_list, :qrcode_url, :play_demo, :call_handle, :handle_gather, :share_facebook, :filter_converted_leads]
  before_filter :check_role_level_permissions, :only => ["show"]
  before_filter :check_current_user_question, :only => [:show, :share_question, :share_email, :share_sms]
  before_filter ->(param='sms_count') { check_current_user_share_access param }, only: %w{share_sms}
  before_filter ->(param='call_count') { check_current_user_share_access param }, only: %w{share_call}
  before_filter ->(param='qr_share') { check_current_user_share_access param }, only: %w{activate_qr}
  before_filter :check_auth_token, :only => [:share_call]
  before_filter :set_maximum_limit,:only =>[:customers_data_grid]
  before_filter :verify_session, :except =>[:qrcode_url, :share_facebook, :filter_converted_leads]
  before_action :kendo_filter_condition, :only => [:share_email, :share_sms, :share_call]
  include ShareSocial
  include SharesHelper

  def show
    get_all_categories
    get_share_privileges
    if valid_email?(current_user.email)
      show_valid_email(params, current_user)
      flash[:notice] = @flash if @flash
    else
      flash[:non_fade_notice] = "Please update or confirm the email address to access this feature."
      redirect_to "/users/edit"
    end
  end


  def social_status_change
    pr,st = params[:provider],params[:status]
    User.social_network_status_change(current_user,pr,st)
    render :json => {:success => "success", :status_code => "200"}
  end

  def customers_data_grid
    @share_type = params["share"]
    respond_to :js
  end

  def customer_data_collection
    @share_type= params[:share_type]
    per_page = 10
    page = params[:page] ? params[:page] : 1
    @filter = JSON.parse(RestClient.post("http://preschoolapi.vanward.co/centrefilter?auth_token=#{session[:auth_token]}",''))
    parsed_response = JSON.parse(RestClient.post("http://preschoolapi.vanward.co/centrescontact?auth_token=#{session[:auth_token]}",''))
    @customers = WillPaginate::Collection.create(page, per_page, 120) do |pager|
      customer = parsed_response.to_a.slice(pager.offset, pager.per_page)
      pager.replace(customer)
    end
    respond_to :js
  end

  def show_email
    @question = Question.get_question(params["id"])
    @email_content = current_user.email_content.present? ? current_user.email_content.gsub('"',"'") : ""
    respond_to :js
  end

  def share_email
    params[:is_html] = params[:is_html] == 'true' ? true : false
    params[:sso] = session[:sso]
    ShareQuestion.share_via_email(params, current_user,@filter,@logic,@sort)
    respond_to do |format|
      format.js { render :js => "window.location = '#{share_path(params[:id])}'" }
      format.json { render json: success({success: 'Successfully share question via mail'}) }
      format.html { render :nothing => true }
    end
  end

  def show_embed_code
    id = params["id"]
    @question = Question.get_question(id)
    @question.update_status_with_expired_at if @question.status.include?("Inactive")
    render :json => {:success => "success", :status_code => "200"}
  end

  def show_sms
    id = params["id"]
    @question = Question.get_question(id)
    respond_to :js
  end

  def share_sms
    params[:sso] = session[:sso]
    @response_message, status_code = ShareQuestion.share_via_sms(params, current_user,@filter,@logic,@sort)
    respond_to do |format|
      format.js { render :js => "window.location = '#{share_path(params[:id])}'" }
      format.json { render :json => ({header: {status: status_code}, body: {message: @response_message}}) }
      format.js
    end
  end

  def show_call_list
    id = params["id"]
    @question = Question.get_question(id)
    @voice_msg = Question.play_demo(id)
    respond_to :js
  end

  def share_call
    params[:sso] = session[:sso]
    @question = Question.get_question(params[:id])
    @custom_url = @question.short_url if @question
    content = User.save_default_content(current_user,params[:call_default_content])
    content = URI::encode(content)
    ShareQuestion.share_via_call(params,@question, current_user, content, @filter, @logic,@sort)
    respond_to do |format|
      format.json { share_call_json_response(params, @question, params[:phone_number], content) }
      format.html
    end
  end

  def make_demo_call
    id ,ph_num, d_cont= params[:id],params[:phone_number],params[:demo_content]
    @question = Question.get_question(id)
    demo_content = URI::encode(d_cont)
    Delayed::Job.enqueue(VoiceJob.new(ph_num.strip.split(","), @question.id, demo_content, "true"), 0)
    render json: success({status: true, msg: "Demo call has been initiated, you will get call soon."})
  end

  def share_to_social_nw
    get_all_categories
    fb_acc, linkedin_acc, twitter_acc = current_user.social_nw_share_question
    user_social_setting
    question_user_info_list(params)
    if (fb_acc.count > 0 || linkedin_acc.count > 0 || twitter_acc.count > 0)
      failure_count_details(params,current_user)
    else
      @flash = "Social network account is not active."
    end
    redirect_to "/share/#{@question.slug}", :notice => @flash
  end

  def share_facebook
    current_user = User.where(id:params["user_id"]).first
    if !current_user.blank?
    fb_acc, linkedin_acc, twitter_acc = current_user.social_nw_share_question
    if (fb_acc.present? && fb_acc.count > 0)
      msg = current_user.facebook_distr_share(params)
      @flash = msg
      else
      @flash = {:status => "error", :msg => "Social network account is not active."}
      end
    else
      @flash = {:status => "error", :msg => "User Not found."}
    end
    respond_to do |format|
      format.js
      format.json {render :json =>  @flash }
      format.html
    end
  end

  def qrdownload
    #rand_string = rand(36**78).to_s(36)
    root_to = Rails.root.to_s
    open("https://chart.googleapis.com/chart?cht=qr&chs=400x400&chl=#{params[:url]}", 'r') do |f|
      pic_file = File.open("#{root_to}/tmp/QR_code.png", 'wb') { |file| file.puts f.read }
      Magick::Image.read("#{root_to}/tmp/QR_code.png").first.write("#{root_to}/tmp/QR_code.#{params[:type]}")
      send_file "#{root_to}/tmp/QR_code.#{params[:type]}", :type => "image/png"
    end
  end


  def call_handle
    @xml = Question.generate_xml(params)
    respond_to do |format|
      format.xml { render :xml => @xml }
    end
  end

  def handle_gather
    @xml = Question.generate_xml_ans(params)
    respond_to do |format|
      format.xml { render :xml => @xml }
    end
  end

  def qrcode_url
    auth_tok = params[:authentication_token]
    u_current = !auth_tok.blank? ? User.find_by_authentication_token(auth_tok) : ""
    @question = Question.where("user_id=? and qrcode_status=?", !u_current.blank? ? u_current.id : params[:user_id], "Active").last
    current_user_question = Question.where(user_id: params[:user_id]).first
    if request.format.symbol.to_s =="json"
      qr_code_url_without_current_user(u_current, @question)
    else
      qr_code_url_blank_question(@question,current_user_question)
    end
  end

  def show_qr
    unless @current_user.check_privilege('qr_share')
      render json: {status: 400, error: "#{APP_MSG['authorization']['failure']}"}
    else
      @questions = current_user.questions
      @questions.update_all(:qrcode_status => "") if @questions
      @question = Question.get_question(params[:id])
      if !@question.nil?
        @question.qrcode_status_update
        qr_code_url = Question.active_qrcode_url(current_user.id, @question)
        render json: success({success: "Question successfully mapped to QR code", qr_code_url: qr_code_url})
      else
        render json: failure({errors: "Invalid question."})
      end
    end
  end

  def check_auth_token
    auth = env["HTTP_AUTHENTICATION_TOKEN"]
    @token = auth.present? ? auth : params[:authentication_token]
    if request.format.symbol.to_s =="json"
      if @token.present? || !@token.nil?
        user = User.find_by_authentication_token(@token)
        if user.nil? || !user.present?
          render json: {error: 'invalid token', status: 1005}
        else
          session[:user_id] = user.id
          params[:question][:user_id] = user.id if params[:action] == "create"
          @user_id = user.id
        end
      else
        render json: {error: 'authentication token missing', status: 1020}
      end
    end
  end

  def activate_qr
    unless @current_user.check_privilege('qr_share')
      render json: {status: 400, error: "#{APP_MSG['authorization']['failure']}"}
    else
      @questions = @current_user.questions
      @questions.update_all(:qrcode_status => "") if @questions
      @question = Question.get_question(params[:id])
      if @question.nil?
        @question.qrcode_status_update
        render json: success({success: "Question successfully mapped to QR code"})
      else
        render json: failure({errors: "Invalid question."})
      end
    end
  end

#Api Qr code generate, send the bitly url based on user based
  def api_qrcode_url
    question = Question.get_question(params[:id])
    common_url = question.custom_url("qr", nil, @current_user.id)
    @current_user.questions.update_all(:qrcode_status => nil)
    question.qrcode_status = "Active"
    question.save(:validate => false)
    question.update_status_with_expired_at if question.status.include?("Inactive")
    render json: success({url: common_url, status_text: "Successfully Qr Code Url was generated and status updated"})
  end

  def check_customer_limit
    user_count = BusinessCustomerInfo.current_user_total_records(current_user)
    render :json => {status: 200, count: (user_count <= 0 ? false : true)}
  end

  def mandril_report
    res = ShareQuestion.delay.mandrill_emails_report(current_user,params)
    render :json => {status: 200, message: "Email report will be sent to '#{current_user.email}' email address shortly."}
  end

  def twillo_call_report
    res = ShareQuestion.twillo_report(current_user,params)
    msg = res == "No data"? "No result found": "Successfully Call report will send to your mail."
    render :json => {status: 200, message: msg}
  end

  def kendo_filter_condition
    @filter = session[:filter]
    @logic = session[:logic]
    @sort = session[:sort]
  end

  def filter_converted_leads
    response = JSON.parse(RestClient.post("http://preschoolapi.vanward.co/authtoken?apikey=#{ENV["LITTLEELLY_KEY"]}",''))
    JSON.parse(RestClient.post("http://preschoolapi.vanward.co/checkadmission?auth_token=#{response["auth_token"]}&centre_key=",''))
    render :json => {status: 200}
  end


end
