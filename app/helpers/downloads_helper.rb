module DownloadsHelper
  def get_question(question_id)
    question = Question.find_by_id(question_id)
    question_text = question.question if question
    return question_text
  end
  #~ def get_customer_info(customer_obj,question,option)
    #~ customer_info = {}
       #~ customer_obj.each do |x|
       #~ x_option =  option.strip == "Comment Type" ? "Comment Type" : x.option
        #~ if x.present? && x.question == question.strip && x_option == option.strip
          #~ customer_info.store(x.customer_name1,[x.email1,x.mobile1,x.country1,x.age1,x.gender1])
          #~ customer_info.store(x.customer_name,[x.email,x.mobile,x.country,x.age,x.gender])
        #~ end
       #~ end
       
       #~ return customer_info.reject!{|k,v|k== nil}
  #~ end
end
