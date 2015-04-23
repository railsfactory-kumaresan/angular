# require 'active_support/concern'
# class Answer
# #  include SolrSearch
#   module Location
#     extend ActiveSupport::Concern
#     included do
#       # def self.get_response_customers_list(id, params,status)
#       #   from_date,to_date,category_id = self.get_from_to_date(params)
#       #   question_id = Question.fetch_question(id).first.id if status == 'show'
#       #   find_question_and_question_ids(params,category_id,status,id)
#       #   question_ids = @question_ids_new
#       #   search = response_customer_list(status,params,question_id,question_ids,category_id,from_date,to_date,id)
#  	    #   return search.hits,search.total
#       # end


#       # def self.response_customer_list(status,params,question_id,question_ids,category_id,from_date,to_date,id)
#       #   QuestionResponseLog.search do
#       #     if status == "show"
#       #       with(:question_id,[question_id])
#       #     else
#       #       with(:question_id, question_ids)  if params['from_date'].present? && params['to_date'].present?
#       #       with(:user_id,id)
#       #       with(:question_category_type_id, category_id) if params["category_id"].to_i != 0
#       #     end
#       #     with(:created_at, "#{from_date}T00:00:00Z".."#{to_date}T23:59:59Z") if from_date.present? && to_date.present?
#       #     with(:customer_country,params[:location])
#       #     paginate(:page => params[:page] || 1,:per_page =>10)
#       #   end
#       # end

#       # def self.get_response_customers_list_excel(id,params)
#       #   from_date,to_date,category_id = self.get_from_to_date(params)
#       #   search = QuestionResponseLog.search do
#       #     with(:user_id,id)
#       #     with(:question_category_type_id, params["category"]) if params["category"].to_i != 0
#       #     with(:created_at, "#{params[:from_date]}T00:00:00Z".."#{params[:to_date]}T23:59:59Z") if from_date.present? && to_date.present?
#       #     without(:customer_name,nil)
#       #   end
#  	    #   return search.hits,search.total
#       # end

#       # def self.viewed_customer_information(id, params,status)
#       #   location = params[:location]
#       #   from_date,to_date,category_id = self.get_from_to_date(params)
#       #   question_id = Question.fetch_question(id).first.id if status == 'show'
#       #   find_question_and_question_ids(params,category_id,status,id)
#       #   question_ids = @question_ids_new
#       #   search = viewed_customer_information_solr(question_id,status,question_ids,id,category_id,params,from_date,to_date)
#       #   return search.hits,search.total
#       # end

#       # def self.find_free_text(question_id, question_type_id, user_id, params)
#       #   y_array =[]
#       #   x_hash = {}
#       #   from_date,to_date,category_id = self.get_from_to_date(params) if !params.blank?
#       #   @search = find_free_text_solr(question_id,user_id,question_type_id,from_date,to_date)
#       #   if question_type_id == 4
#       #     y_array =y_array_values(@search,"comments")
#       #   else
#       #     y_array = y_array_values(@search,"free_text")
#       #   end

#       #   return y_array
#       # end

#       # def self.find_free_text_solr(question_id,user_id,question_type_id,from_date,to_date)
#       #    Answer.search do
#       #     all_of do
#       #       with(:question_id, [question_id])
#       #       with(:question_owner_id, user_id)
#       #       with(:question_type_id, question_type_id)
#       #       any_of do
#       #         with(:created_at,"#{from_date}T00:00:00Z".."#{to_date}T23:59:59Z") unless from_date.blank?
#       #       end
#       #     end
#       #     facet :comments
#       #     facet :free_text
#       #   end
#       # end

#       # def self.y_array_values(search,op)
#       #   y_array =[]
#       #   x_hash = {}
#       #   search.facet(:"#{op}").rows.each do |facet|
#       #     x_hash = {:value => facet.value, :count => facet.count}
#       #     y_array << x_hash
#       #   end
#       #   return y_array
#       # end

#       # def self.find_all_responses(id, params)
#       #   y_array =[]
#       #   x_hash = {}
#       #   id = Question.find(id).id
#       #   from_date,to_date,category_id = self.get_from_to_date(params) if !params.blank?
#       #   @search = find_all_response_solr(id,from_date,to_date)
#       #   y_array = y_array_values(@search,"option")
#       #   return y_array
#       # end


#       # def self.collection_of_countries(id, status,params = nil)
#       #  from_date,to_date,category_id = self.get_from_to_date(params) if !params.blank?
#       #   question_id = Question.where("id = ?",id).pluck(:id) if status == 'show'
#       #  find_question_and_question_ids(params,category_id,status,id)
#       #  @questions = @question
#       #  question_ids = @question_ids_new
#       #  search_view = collection_of_countries_solr(question_id,status,question_ids,id,category_id,params,from_date,to_date)
#       #   view_countries = search_view.facet(:customer_country).rows
#       # end

#       # def self.get_country_based_res_count(country,question_id,id,params,status)
#       #   question_id = question_id.present? ? question_id : ''
#       #   location = country
#       #   from_date,to_date,category_id = self.get_from_to_date(params)
#       #   question_ids = @question_ids_new
#       #   search = QuestionResponseLog.search do
#       #     if (status == "show")
#       #       with(:question_id,[question_id])
#       #     else
#       #       with(:question_id, question_ids)  if params[:from_date].present? && params[:to_date].present?
#       #       with(:user_id,id)
#       #       with(:question_category_type_id,category_id) if category_id != 0
#       #     end
#       #     with(:customer_country,location)
#       #     with(:created_at, "#{from_date}T00:00:00Z".."#{to_date}T23:59:59Z") if from_date.present? && to_date.present?
#       #   end
#       #   return search.total
#       # end

#       # def self.get_from_to_date(params)
#       #   from_date = params[:from_date].present? ? params[:from_date].to_date.strftime("%Y-%m-%d") : ''
#       #   to_date = params[:to_date].present? ? params[:to_date].to_date.strftime("%Y-%m-%d") : ''
#       #   category_id = params[:category].present? ? params[:category].to_i :  params[:category_id].to_i

#       #   return from_date,to_date,category_id
#       # end
#       end
#   end
# end