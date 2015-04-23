# module SolrSearch
#   extend ActiveSupport::Concern
#   included do
#     def self.find_all_response_solr(id,from_date,to_date)
#       Answer.search do
#         all_of do
#           with(:question_id, [id])
#           without(:question_option_id, nil)
#           without(:option, nil)
#           without(:option, " ")
#           any_of do
#             with(:created_at,"#{from_date}T00:00:00Z".."#{to_date}T23:59:59Z") unless from_date.blank?
#           end
#         end
#         facet :option
#       end
#     end

#     def self.viewed_customer_information_solr(question_id,status,question_ids,id,category_id,params,from_date,to_date)
#       search = QuestionViewLog.search do
#         if status == "show"
#           with(:question_id,[question_id])
#         else
#           with(:question_id, question_ids)  if params[:from_date].present? && params[:to_date].present?
#           with(:user_id,id)
#           with(:question_category_type_id, category_id) if category_id != 0
#         end
#         with(:created_at, "#{from_date}T00:00:00Z".."#{to_date}T23:59:59Z") if params[:from_date].present? && params[:to_date].present?
#         with(:customer_country,params[:location])
#         paginate(:page => params[:page] || 1,:per_page =>10)
#       end
#       return search
#     end

#     def self.collection_of_countries_solr(question_id,status,question_ids,id,category_id,params,from_date,to_date)
#       QuestionViewLog.search do
#         # group(:cookie_token_id,:question_id)1
#         if status == "show"
#           with(:question_id,question_id)
#         else
#           with(:question_id, question_ids)  if params[:from_date].present? && params[:to_date].present?
#           with(:user_id,id)
#           with(:question_category_type_id,category_id) if category_id != 0
#         end
#         with(:created_at,"#{from_date}T00:00:00Z".."#{to_date}T23:59:59Z") unless from_date.blank?
#         facet(:customer_country)
#       end
#     end

#     def self.find_question_and_question_ids(params,category_id,status,id)
#       frm ,to_da,cid = params[:from_date],params[:to_date],category_id
#       if frm.present? && to_da.present? && status != "show"
#         @question = Question.where("DATE(created_at) >= ? AND DATE(created_at) <= ? AND user_id = ? AND category_type_id =?",frm,to_da,id,cid) if cid != 0
#         @question = Question.where("DATE(created_at) >= ? AND DATE(created_at) <= ? AND user_id = ?",frm,to_da,id) if cid == 0
#         @question_ids = @question.pluck(:id) if @question.present?
#         @question_ids_new = @question_ids.present? ? @question_ids : ''
#       end
#     end

#   end
# end