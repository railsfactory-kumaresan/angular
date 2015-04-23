require "spec_helper"

describe Answer do

  before(:each) do
    @user = FactoryGirl.create(:user, :default_biz_user)
    @response_user = FactoryGirl.create(:user, :default_user)
    @cookie_token = FactoryGirl.create(:cookie_token)

    # Create question
    Question.delete_all
    @question = Question.new
    @question.user_id = @user.id
    @question.question_type_id = QuestionType.pluck(:id).first
    @question.category_type_id = CategoryType.pluck(:id).first
    @question.include_comment = false
    @question.question = "Who am I?"
    @question.thanks_response = "A movie fan!"
    @question.language = "English"
    @question.expiration_id = "1 Year"
    @question.expired_at = Time.now + 1.year
    @question.status = "Active"
    @question.embed_url = "Aj8l2Kqty"
    @question.save


    # Create question option and try to save it
    QuestionOption.delete_all
    @question_option = QuestionOption.new
    @question_option.question_id = @question.id
    @question_option.option = "Some option statement"
    @question_option.order = 1
    @question_option.is_other = false
    @question_option.is_deactivated = false
    @question_option.save

    # Create an Anser that can be saved
    Answer.delete_all
    @answer = Answer.new
    @answer.customers_info_id = @response_user.id
    @answer.question_id = @question.id
    @answer.provider = "Some Provider"
    @answer.comments = "Able Was I Ere I Saw Elba"
    @answer.free_text = "Use free software. Be free."
    @answer.question_option_id = @question_option.id
    @answer.question_type_id = @question.question_type_id
    @answer.option = "Some option"
    @answer.is_business_user = false
    @answer.is_deactivated = false
    @answer.is_other = false
    @answer.uuid = "some uuid" #in truth this must be ISO standard UUID
  end

  # it { should belong_to(:question_options) }

  # QuestionOption belongs to Question ans Answer
  # belongs to QuestionOptions
  # but having a Question -> Answe direct relationship
  # will prevent table hopping, thus enhanching performance
describe "#association" do
  it { should belong_to(:question) }
  it { should belong_to(:response_customer_info) }
  it { should belong_to(:business_customer_info) }
end
  # it "when empty should not be savable" do
  #   expect(Answer.new.save).to eq(false)
  # end

  it "shold be creatable" do
    expect(@answer.save).to eq(true)
  end

  describe "answer_datetime_split" do
    it "date column must be populated automatically after save" do
      @answer.save
      expect(@answer.date).to eq(DateTime.now.day)
    end

    it "month column must be populated automatically after save" do
      @answer.save
      expect(@answer.month).to eq(DateTime.now.month)
    end

    it "year column must be populated automatically after save" do
      @answer.save
      expect(@answer.year).to eq(DateTime.now.year)
    end

    it "hour column must be populated automatically after save" do
      @answer.save
      expect(@answer.hour).to eq(DateTime.now.hour)
    end
  end

  describe "self.share_status_response" do
    it "must give 0 as response if wrong details are given" do
      @answer.save
      expect(Answer.share_status_response("Facebook", @question.id)).to eq(0)
    end
    it "must give count of response if correct details are given" do
      @answer.provider = "Facebook"
      @answer.save
      expect(Answer.share_status_response("Facebook", @question.id)).to eq(1)
    end
  end

  describe "self.share_status" do
    it "must give 0 as response if wrong details are given" do
      @answer.save
      expect(Answer.share_status("Facebook", @question.id)).to eq(0)
    end
    it "must give count of response if correct details are given" do
      @answer.provider = "Facebook"
      @answer.save
      expect(Answer.share_status_response("Facebook", @question.id)).to eq(1)
    end
  end
  
  describe "find_question_response_count" do
    it "must give 0 as response if wrong details are given" do
      @answer.save
      expect(Answer.find_question_response_count(nil)).to eq(0)
    end
    it "must give count of response if correct details are given" do
      @answer.save
      expect(Answer.find_question_response_count(@question.id)).to eq(1)
    end
  end  
  
  describe "find_answers" do
    it "must give empty result as response if wrong details are given" do
      @answer.save
      expect(Answer.find_answers(nil).last).to eq(nil)
    end
    it "must give question of response if correct details are given" do
      @answer.save
      expect(Answer.find_answers(@question.id).last).to eq(@answer)
    end
  end   
  #~ describe "self.question_response" do
    #~ # it "must search for answers when right parameters are given" do
    #~ #   @answer.save
    #~ #   params = {
    #~ #     from_date: Time.now - 1.year,
    #~ #     to_date: Time.now + 1.year,
    #~ #     id: @question.id # This is question id
    #~ #   }
    #~ #   expect(Answer.question_response(params)).to eq([@answer])
    #~ # end

    #~ it "must not return result when from_date is out of bound" do
      #~ @answer.save
      #~ params = {
        #~ from_date: Time.now + 3.months,
        #~ to_date: Time.now + 1.year,
        #~ id: @question.id # This is question id
      #~ }
      #~ expect(Answer.question_response(params)).to eq([])
    #~ end

    #~ it "must not return result for wrong question id" do
      #~ @answer.save
      #~ params = {
        #~ from_date: Time.now - 1.months,
        #~ to_date: Time.now + 1.year,
        #~ id: Question.maximum(:id) + 1 # This is question id
      #~ }
      #~ expect(Answer.question_response(params)).to eq([])
    #~ end
  #~ end

  #~ describe "self.update_customer_info" do

    #~ # This is just present to see if redis is working
    #~ it "must update redis" do
      #~ # Start the redis server before you run this
      #~ r = Redis.connect
      #~ r.set "sjdfggfsdmg", "boom thata"
      #~ expect(r.get("sjdfggfsdmg")).to eq("boom thata")
      #~ r.del "sjdfggfsdmg"
    #~ end

    #~ # it "must "
    #~ # paused it, because I must get to know ho exactly QuestionViewLog
    #~ # is indexed

  #~ end

  describe "self.create_free_text" do
    it "must create answer with other option" do
      Answer.delete_all
      params = {
        other_answer_option: "A new other option",
        question_id: @question.id,
        provider: "Twitter"
      }
      uuid = @cookie_token.uuid
      type_id = @question.question_type_id
      id = @response_user
      is_business_user = 1
      FactoryGirl.create(:business_customer_info, id: @user.id, user_id: @user.id, question_id: @question.id)
      Answer.create_free_text(params, type_id, @user,uuid, is_business_user)
      expect(Answer.count).to eq(1)
    end
  end

  describe "self.create_comment_response" do
    it "must create comment with response" do
      Answer.delete_all
      comment = "Some comment string"
      customer_id = @response_user.id
      uuid = @cookie_token.uuid
      question_id = @question.id
      question_type_id = @question.question_type_id
      provider = "Twitter"
      business_user = 1 # set as individual user
      Answer.create_comment_response(comment, customer_id = nil,uuid,question_id,
        question_type_id,provider,business_user)
      expect(Answer.first.comments).to eq(comment)
    end
  end

  describe "self.check_already_answered" do
    it "must return false when there are no answers" do
      Answer.delete_all
      result = Answer.check_already_answered(@question.id, @response_user.id,"Email")
      expect(result).to eq(false)
    end

    it "must return true if the question is answered" do
      @answer.provider = "Email"
      @answer.save
      result = Answer.check_already_answered(@question.id, @response_user.id, "Email")
      expect(result).to eq(true)
    end
  end

  describe "self.create_other_option" do
    it "must create other option" do
      Answer.delete_all
      params = {
        other_answer_option: "Answer option",
        question_id: @question.id,
        provider: "Twitter"
      }
      uuid = CookieToken.create(uuid: "unique rand id").id
      type_id = @question.question_type_id
      other_option_id = @question_option.id
      business_user = 1 # Seting it as individual user
      customer_info = @response_user.id
      Answer.create_other_option(params,customer_info,uuid,type_id,other_option_id,business_user)
      expect(Answer.first.option).to eq(params[:other_answer_option])
    end
  end


  describe "find_comments_free_text" do
    it "For question type id as 4" do
      @question.question_type_id = 4
      @question.save
      expect(Answer.find_comments_free_text(@question)).to eq({})
    end
    it "must give count of response if correct details are given" do
      expect(Answer.find_comments_free_text(@question)).to eq({})
    end
    it "must give 0 response if question details are not given" do
      expect(Answer.find_comments_free_text(Question.new)).to eq({})
    end    
  end
   
end