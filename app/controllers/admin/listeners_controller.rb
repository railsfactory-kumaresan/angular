class Admin::ListenersController < ApplicationController
  before_filter :check_admin,:except => ["request_listner", "share_listener"]
  #~ before_filter :check_role_level_permissions, :only => ["index"]
  layout 'admin_layout'
  before_filter :authenticate_user_web_api

  def list_listeners
  end

  #~ def index
    #~ @user = Listener.where("is_requested is TRUE").order("status DESC,updated_at DESC").group("listeners.id,listeners.status")
    #~ build_json
    #~ render :json => @list_listener
  #~ end

  #~ def request_listner
    #~ listener_user = Listener.fetch_listener(current_user.id)
    #~ if listener_user.blank?
      #~ email = current_user.email
      #~ client_id = SecureRandom.uuid
      #~ username = email.split("@")[0].slice(0...5)+client_id.reverse.slice(0...4)
      #~ password = "Pwd"+email.split("@")[0].reverse.slice(0...3)+client_id.slice(0...3)
      #~ @listener_user = Listener.create(:email=> email,:status=>"Open", :user_id=> current_user.id,:company_name => current_user.company_name,:is_requested => true,:client_id => client_id ,:username => username,:password =>password)
      #~ render :json => {:status => 200}
    #~ else
      #~ render :json => {:status => 500}
    #~ end
  #~ end

  #~ def activate_listener
    #~ @listener_user = Listener.fetch_listener(params[:id]).first
    #~ first_name = @listener_user.user && @listener_user.user.first_name ? @listener_user.user.first_name : ''
    #~ if @listener_user.present?
      #~ @listener_user.is_active = true
      #~ @listener_user.status = "Closed"
      #~ @listener_user.save
      #~ ListenerMailer.activate_listener_email(@listener_user,"Inquirly Listen Module Activation",current_user.email,first_name).delay
      #~ flash[:notice] = APP_MSG["listener"]["activated"]
      #~ redirect_to "/admin/listeners/list_listeners"
    #~ else
      #~ flash[:notice] = APP_MSG["listener"]["invalid_id"]
      #~ redirect_to "/admin/listeners/list_listeners"
    #~ end
  #~ end

  #~ def build_json
    #~ @list_listener = []
    #~ @user.each do |user|
      #~ json = {}
      #~ json['id'] = user.id
      #~ json['email'] = user.email
      #~ first_name = user.user && user.user.first_name ?  user.user.first_name : ''
      #~ json['first_name'] = first_name
      #~ json['user_id'] = user.user_id
      #~ json['client_id'] = user.client_id
      #~ json['company_name'] = user.company_name
      #~ json['username'] = user.username
      #~ json['password'] = user.password
      #~ json['is_active'] = user.is_active
      #~ json['status'] = user.status
      #~ @list_listener << json
    #~ end
  #~ end

  def share_listener
      msg = ""
      begin
      current_user = User.where(authentication_token: params[:authenticity_token]).first
      InviteUser.send_listener_share_email(current_user, params).deliver
      msg = {status: "success",message: "Email sent"}
      rescue Exception => e
       msg = {status:"error",message:"Unable to send email"}
      end
     respond_to do |format|
       format.js
       format.json {render :json => msg}
       format.html
     end
   end

  #~ def check_admin
    #~ if !current_user.blank?
    #~ admin_true = User.where(id: current_user.id, admin: true)
    #~ if admin_true.blank?
      #~ flash[:notice] = "You are not authorized to access admin details."
      #~ redirect_to "/"
    #~ end
    #~ else
      #~ flash[:notice] = "You are not authorized to view this page."
      #~ redirect_to "/"
    #~ end
  #~ end
end
