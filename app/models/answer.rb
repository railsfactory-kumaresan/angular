class Answer < ActiveRecord::Base
  include AnswerValidation

  def self.share_status_response(social_id, question_id)
    responses = where("question_id = ? and ((question_option_id is not null and option is not null and option <> '') or comments is not null) and provider = ? and is_deactivated is false",question_id,social_id)#.select('distinct(multiple_response_id)')
    responses = responses.blank? ? 0 : responses.length
  end


  def self.share_status(social_id,question_id)
    responses =  where("question_id = ? and provider = ? and is_deactivated is false",question_id,social_id)#.select('distinct(multiple_response_id)')
    responses = responses.blank? ? 0 : responses.length
  end

  def self.find_question_response_count(id)
    responses =  self.find_answers(id)
    responses.nil? ? 0 : responses.length
  end

   def self.find_answers(id)
     where("question_id = ? and ((question_option_id is not null and option is not null and option <> '') or comments is not null)",id)
   end

  def self.create_multiple_responses(index,params,o_id,is_other,c_info = nil,uuid,q_id,q_type_id,provider,b_user)
    option = QuestionOption.find_question_option(o_id)
    qt_id,op_id,q_id,pro,i_o= q_type_id,o_id,q_id,provider,is_other
    cu,bu = c_info,b_user
    Answer.create(:question_type_id =>qt_id,:question_option_id =>op_id,:uuid=>uuid,:question_id=>q_id,:provider=>pro,
                  :option=>option,:is_deactivated=>false,:is_other=>i_o,:customers_info_id => cu,:is_business_user=>bu)
  end

  def self.update_customer_info(customer_id,uuid,is_business_value,question_id)
    answers= Answer.where(:uuid=>uuid,:question_id=>question_id)
    answers.update_all(:customers_info_id => customer_id,:is_business_user => is_business_value)
    QuestionResponseLog.change_process_status(uuid,question_id,customer_id)
  end

  def self.create_other_option(params,customer_info,uuid,type_id,other_option_id,business_user)
    Answer.create(:question_type_id => type_id,:option =>params[:other_answer_option],:uuid=>uuid,:question_id=>params[:question_id],:provider=>params[:provider],:question_option_id=>other_option_id,:is_deactivated=>false,:is_other=>true,:is_business_user=>business_user,:customers_info_id=>customer_info)
  end

  # Creates a free text type answer
  def self.create_free_text(params,type_id, id,uuid,business_user)
    Answer.create(:question_type_id =>type_id,:uuid=>uuid,:question_id=>params[:question_id],:provider=>params[:provider],:free_text=>params[:include_text],:is_deactivated=>false, :customers_info_id => id,:is_business_user=>business_user)
  end

  def self.create_comment_response(comment, customer_id = nil,uuid,question_id,question_type_id,provider,business_user)
    Answer.create(:question_type_id =>question_type_id ,:uuid=>uuid,:question_id=>question_id,:provider=>provider,:is_deactivated=>false,:comments=>comment, :customers_info_id => customer_id,:is_business_user=>business_user)
  end

 def self.check_already_answered(question_id,cus_id, provider)
    answer = where("question_id=? and customers_info_id=? and provider=?",question_id,cus_id, provider)
    answer.blank? ? false : true
  end


  # Creates a multiple response for a question
  def self.multiple_responses(params,other_option_id,question,customer_info_id=nil,uuid_id=nil,is_business_user=nil)
    m_an,m_oth,prov = params[:multiple_answers],params[:other_answer_option],params[:provider]
    res = !m_an.blank? && !m_oth.blank?
    un_processed_ids = []
    if res && m_an == m_oth
      answer =  self.create_multiple_responses(0,params,other_option_id,true,customer_info_id,uuid_id,question.id,question.question_type_id,prov,is_business_user)
      un_processed_ids << answer.id if answer.customers_info_id.nil? || answer.customers_info_id == 0
    else
      other_ans = self.create_other_option(params,customer_info_id,uuid_id,question.question_type_id,other_option_id,is_business_user) unless m_oth.blank?
      un_processed_ids << other_ans.id if other_ans && (other_ans.customers_info_id.nil? || other_ans.customers_info_id == 0)
      options =  m_an.split(',') unless m_an.blank?
      options && options.each_with_index do |option_id,index|
        if m_oth != option_id
         multiple_ans = self.create_multiple_responses(index,params,option_id,false,customer_info_id,uuid_id,question.id,question.question_type_id,prov,is_business_user)
         un_processed_ids << multiple_ans.id if multiple_ans.customers_info_id.nil? || multiple_ans.customers_info_id == 0
        end
      end
    end
    return un_processed_ids
  end

  # Creates a single response for a question
  def self.single_responses(params,other_option_id,question,customer_info_id=nil,uuid_id=nil,is_business_user=nil)
     option=QuestionOption.where("question_id=? and option =?",question.id,params[:answer_option])[0]
     is_other_option = (option && option.is_other) ? true : false
     if question.question_type_id == 4
      answer = self.create_comment_response(params[:answer_option],customer_info_id,uuid_id,question.id,question.question_type_id,params[:provider],is_business_user)
     else
      answer = self.create_multiple_responses(0,params,option.id,is_other_option,customer_info_id,uuid_id,question.id,question.question_type_id,params[:provider],is_business_user)
     end
     return answer.id if answer.customers_info_id.nil? || answer.customers_info_id == 0
  end

  def self.find_comments_free_text(question)
   if  question.question_type_id == 4
    answers = where("question_id = ? and comments is not null",question.id).select("comments").group('comments').count
   else
    answers = where("question_id = ? and free_text is not null",question.id).select("free_text").group('free_text').count
   end
  end

end
