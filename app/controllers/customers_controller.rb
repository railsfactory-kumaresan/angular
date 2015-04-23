require 'will_paginate/array'
class CustomersController < ApplicationController
  before_filter :authenticate_user_web_api

  def index
		@business_customer_infos =  BusinessCustomerInfo.get_customer_records(current_user.id,params[:share_type],params[:sort], params[:filter],params[:logic],params[:top].to_i)
    session[:filter] = params[:filter]
    session[:logic] = params[:logic]
    session[:sort] = params[:sort]
    business_customer_infos = @business_customer_infos.paginate(:page => params[:page], :per_page => params[:top].to_i).offset(params[:skip].to_i) unless @business_customer_infos.empty?
    render :json => business_customer_infos.present? ? BusinessCustomerInfo.build_business_customer_json(business_customer_infos,current_user.id,@business_customer_infos.count,params) : {}
	end

	def create
    user_data = customer_params
    user_data['gender'] = user_data['gender'].capitalize
    business_cus_info = BusinessCustomerInfo.insert_new_business_customer(user_data,current_user)
    render_json(business_cus_info)
  end

	def update
    biz_customer_info = BusinessCustomerInfo.where(email: params["customer"]["email"], user_id: current_user.id).first
    params["customer"]["mobile"] = BusinessCustomerInfo.update_country_code(params,biz_customer_info.country,biz_customer_info.mobile)
    biz_customer_info.update_attributes(params.require(:customer).permit(:customer_name,:email,:mobile,:age, :gender,  :country, :state ,:area, :city,  :id, :custom_field))
    render_json(biz_customer_info)
   end

  def render_json(bc)
    country = bc.country ? Country.find_country_by_alpha2(bc.country) : ""
    country_alpha = country.present? ? country.alpha2 : ""
    country_name = country.present? ? country.name : ""
    render :json => {:email => bc.email, :id => bc.id,:customer_name => bc.customer_name , :mobile => bc.mobile,
                     :area => bc.area, :city => bc.city, :age => bc.age,:state => bc.state, :country => bc.country,
                     :gender => bc.gender, :country_code => {"code" => country_alpha, "name" => country.name }  }
  end

	def destroy
    BusinessCustomerInfo.where(id: params['id']).last.update(:is_deleted => true)
		render :json => {status: 200}
  end

  def delete_selected
    destroy
  end

  def remove_social_account
    account = ShareQuestion.where(id: params[:id]).first
    if account
     status = 200
     account.destroy
    else
     status = 403
    end
    render :json => {status: status}
  end

  def get_customer_email
    @customer_email = @current_user.business_customer_infos.pluck(:email) if @current_user.business_customer_infos
    @customer_email.present? ? (render json: success({ customer_email:@customer_email})) : (render json: failure({ errors: "No customer details found" }))
  end

	def email_duplication_check
    check_duplication(params)
	end

	def mobile_duplication_check
		params["mobile"] = "91#{params["mobile"]}" if params["mobile"].length == 10
    check_duplication(params)
  end

  private

  def customer_params
    params.require(:models).permit(:customer_name, :email, :mobile, :age, :gender, :country, :city, :state, :area, :custom_field, :status, :country_code)
  end

  def check_duplication(params)
     if params[:id].present?
       business_customer = BusinessCustomerInfo.check_email_and_mobile_duplication(params,current_user)
       render :json => {:result => (business_customer.errors[:email].present? || business_customer.errors[:mobile].present?)  ? true : false}
     else
       business_customer = BusinessCustomerInfo.mobile_and_email_check_if_id_nil(params,current_user)
       render :json => {:result => business_customer.present? ? true : false}
     end
  end

end
