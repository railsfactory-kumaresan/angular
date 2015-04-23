require "spec_helper"
include ActionView::Helpers::DateHelper

# there is something really fishy about category_type_id
# should ask some one who knows this project

describe Question do

  before(:each) do
    Question.any_instance.stub(:generate_bitly_url).and_return("http://bitly.com")

    User.delete_all
    @user = User.new
    @user.first_name = "John"
    @user.last_name = "Taylor"
    @user.company_name = "Sedin Technologies"
    @user.business_type_id =  2 # setting it as business user
    @user.email = "karthikeyan@railsfactory.com"
    @user.confirmed_at = Time.now - 1.hour
    @user.confirmation_sent_at = Time.now - 2.hour
    @user.is_active = true
    @user.admin = false
    @user.password = "12345678aA!"
    @user.password_confirmation = "12345678aA!"
    @user.save

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
    @question.embed_url = "http://google.com"
    @question.video_url = "http://youtube.com"
  end

describe "#Association" do
  it { should belong_to(:user)}
  it {should have_one(:attachment)}
  it {should have_one(:question_style)}
  it { should have_many(:answers) }
  it {should have_many(:question_view_logs)}
  it {should have_many(:question_response_logs)}
  it {should belong_to(:category_type)}
  it {should have_many(:question_options)}
end
describe "#Validation" do
  it { should validate_presence_of(:question).with_message('Please enter the question.') }
end
  it "should be creatable" do
    expect(@question.save).to eq(true)
  end

  # it "should not allow non-url string for video_url" do
  #   @question.video_url = "this is not url"
  #   expect(@question.save).to eq(false)
  # end

  # it "embed_url must be not less than 5 characters" do
  #   @question.embed_url = "abc"
  #   expect(@question.save).to eq(false)
  # end


  # it "must be not created if user_id is nil" do
  #   @question.user_id = nil
  #   expect(@question.save).to eq(false)
  # end


=begin
  # Testing self.find_question_list(category_id, status, current_user, limit, per_page)

  it "find a list of questions" do
    # not working because of Solr issue
    @question.status = "Active"
    @question.category_type_id = 1
    @question.save
    expect(Question.find_question_list(1, "Active", @user.id, 1, 10)).to eq([@question])
  end
=end

  # Testing self.validate_email

  it "must not return errors if email is valid" do
    expect(Question.validate_email("abc@google.com")).to eq({})
  end

  it "must return Please enter an email if no email is given" do
    expect(Question.validate_email("")[:email]).to eq("Please enter an email")
  end

  it "must return Please enter an email if no email is given" do
    expect(Question.validate_email("non email")[:email]).to eq("Please enter a valid email address")
  end

  # Testing is_expired?

  #~ it "must say expired if expiry date is older than today" do
    #~ @question.expired_at = Time.now + 1.year
    #~ @question.save
    #~ expect(@question.is_expired?).to eq(false)
  #~ end

  # Testing self.find_question

  #~ it " must find the question matching the id" do
    #~ @question.save
    #~ expect(Question.find_question(@question.id)).to eq([@question])
  #~ end

  # Testing self.get_question_expiration

  it "must get question expitration as 1 day" do
    @question.expired_at = Time.now + 1.day
    @question.save
    exp_number = Question.get_question_expiration(@question)
    diff = exp_number -  1.day.to_i
    expect(diff.abs < 10).to eq(true)
  end

  it "must get question expitration as 1 day" do
    @question.expiration_id = "1 Day"
    @question.status = "Inactive"
    @question.save
    exp_number = Question.get_question_expiration(@question)
    expect(exp_number).to eq(1)
  end

  it "must get question expitration as 1 month" do
    @question.expiration_id = "1 Month"
    @question.status = "Inactive"
    @question.save
    exp_number = Question.get_question_expiration(@question)
    expect(exp_number).to eq(Time.days_in_month(Time.now.strftime("%m").to_i))
  end

  it "must get question expitration as 1 Year" do
    @question.expiration_id = "1 Year"
    @question.status = "Inactive"
    @question.save
    exp_number = Question.get_question_expiration(@question)
    boolean = (exp_number < 366) and (exp_number >= 365)
    expect(exp_number > 31500000).to eq(true)
  end

  it "must get question expitration as 1 Year" do
    @question.expiration_id = "1 Week"
    @question.status = "Inactive"
    @question.save
    exp_number = Question.get_question_expiration(@question)
    expect(exp_number).to eq(7)
  end

  # Testing self.find_category_type_id

  it "must find question with id" do
    @question.save
    expect(Question.find_category_type_id(@question.id)).to eq(@question)
  end

  # Testing self.get_question

  it "must get question with id in get_question" do
    @question.save
    expect(Question.get_question(@question.id)).to eq(@question)
  end

  it "must get question with slug in get_question" do
    @question.save
    expect(Question.get_question(@question.slug)).to eq(@question)
  end

  # Testing self.find_question_owner

  it "must find question for given id" do
    @question.save
    expect(Question.find_question_owner(@question.id)).to eq(@question)
  end

  # Testing check_status

  it "must output the status of question" do
    @question.status = "Active"
    @question.save
    expect(@question.check_status).to eq(@question.status)
  end


  # Testing answers_count

  it "must return number of answers the question has" do
    @question.save
    QuestionOption.delete_all
    QuestionOption.add_question_options(%w(A B C D), @question.id, 1, false)
    # Create an Answer that can be saved
    Answer.delete_all
    @answer = Answer.new
    @answer.customers_info_id = @user.id
    @answer.question_id = @question.id
    @answer.provider = "Some Provider"
    @answer.comments = "Able Was I Ere I Saw Elba"
    @answer.free_text = "Use free software. Be free."
    @answer.question_option_id = QuestionOption.first.id
    @answer.question_type_id = @question.question_type_id
    @answer.option = "Some option"
    @answer.is_business_user = false
    @answer.is_deactivated = false
    @answer.is_other = false
    @answer.uuid = "some uuid" #in truth this must be ISO standard UUID
    @answer.save

    expect(@question.answers_count).to eq(1)
  end

  describe 'MAR_CR - question_latest_style_apply' do
    before(:each){
      User.delete_all
      Question.delete_all
      Attachment.delete_all
      @user = FactoryGirl.create(:user, :user_all)
      @question = FactoryGirl.create(:question ,:year_wise_expire,:user_id => @user.id,:question_type_id => QuestionType.first.id,:category_type_id => CategoryType.first.id, :video_url => "http://google.com", :embed_url => "http://google.com")
      @attachement =  Attachment.create(:image => File.new(Rails.root + 'spec/fixtures/1.jpg'), :attachable_id => @question.id,:attachable_type => "Question")
      @question_style = FactoryGirl.create(:question_style, :question_id => @question.id )
    }
    it "it should return previous question style" do
       question = FactoryGirl.create(:question ,:year_wise_expire,:user_id => @user.id,:question_type_id => QuestionType.first.id,:category_type_id => CategoryType.first.id)
       question_new = Question.find question.id
       question_new.question_latest_style_apply(@user,@question)
       expect(QuestionStyle.count).to eq 2
       expect(QuestionStyle.last.background).to eq @question_style.background
       expect(QuestionStyle.last.page_header).to eq @question_style.page_header
       expect(QuestionStyle.last.submit_button).to eq @question_style.submit_button
       expect(QuestionStyle.last.question_text).to eq @question_style.question_text
       expect(QuestionStyle.last.button_text).to eq @question_style.button_text
       expect(QuestionStyle.last.answers).to eq @question_style.answers
    end

    it "it should empty question style" do
     question = FactoryGirl.create(:question ,:year_wise_expire,:user_id => @user.id,:question_type_id => QuestionType.first.id,:category_type_id => CategoryType.first.id)
     question_new = Question.find question.id
     expect(QuestionStyle.count).to eq 1
   end

    it "it should return previous logo" do
     question = FactoryGirl.create(:question ,:year_wise_expire,:user_id => @user.id,:question_type_id => QuestionType.first.id,:category_type_id => CategoryType.first.id)
     question_new = Question.find question.id
     question_new.question_latest_style_apply(@user,@question)
     expect(Attachment.count).to eq 1
     expect(Attachment.last.image_file_name).to eq  @attachement.image_file_name
   end

    it "it should validate the image file format" do
      question_prev = FactoryGirl.create(:question ,:year_wise_expire,:user_id => @user.id,:question_type_id => QuestionType.first.id,:category_type_id => CategoryType.first.id)
      attachement =  Attachment.create(:image => File.new(Rails.root + 'spec/fixtures/1.jpg'), :attachable_id => question_prev.id,:attachable_type => "Question")
      expect(attachement.errors[:image]) =~ "Paperclip::Errors::NotIdentifiedByImageMagickError"
    end
  end

  describe "#get_number_of_days" do
    it "must output 1 for day" do
      expect(@question.get_number_of_days("day")).to eq 1
    end

    it "must output 7 for week" do
      expect(@question.get_number_of_days("week")).to eq 7
    end

    it "must output 30 for month" do
      expect(@question.get_number_of_days("month")).to eq 30
    end

    it "must output 365 for year" do
      expect(@question.get_number_of_days("year")).to eq 365
    end
  end

  describe "#play_demo" do
    it "must return right play demo string" do
      @question.save
      expect(Question.play_demo(@question.id)).to match(/Inquirly Feedback Services,Please Answer The Question/)
    end
  end

=begin
  describe "#question_status" do
    it "must change question status to closed if the question has expired" do
      @question.status = "Active"
      @question.expired_at = 1.month.ago
      @question.expiration_id = "1 Week"
      @question.save
      Question.question_status
      expect(@question.status).to eq("Closed")
    end
  end
=end

  # describe "#get_questions" do
  #   it "must get array of questions if right details with category id is given" do
  #     @question.save
  #     result = Question.get_questions(@user, Time.now-1.day, Time.now+1.month, @question.category_type_id)
  #     expect(result).to eq([@question])
  #   end

  #   it "must get array of questions if right details even if category tpe is not given" do
  #     @question.save
  #     # we pass nil for category type id
  #     result = Question.get_questions(@user, Time.now-1.day, Time.now+1.month, nil)
  #     expect(result).to eq([@question])
  #   end
  # end

  describe "#update_status_with_expired_at" do
    it "must set expired time to 1 week from now" do
      @question.expiration_id = "1 Week"
      @question.save
      @question.update_status_with_expired_at
      expect(distance_of_time_in_words(@question.expired_at - Time.now.utc)).to eq("7 days")
      # base_time = eval(@question.expiration_id.strip.downcase.gsub(/\s+/, ".")).from_now
      # start_boundry = (base_time - 5.minutes) < @question.expired_at
      # end_bound = (base_time - 5.minutes) < @question.expired_at
      # expect(start_boundry).to eq(true)
      # expect(end_bound).to eq(true)
    end

    it "must set expired time to 1 month from now" do
      @question.expiration_id = "1 Month"
      @question.save
      @question.update_status_with_expired_at
      #base_time = eval(@question.expiration_id.strip.downcase.gsub(/\s+/, ".")).from_now
      #start_boundry = (base_time - 5.minutes) < @question.expired_at
      #end_bound = (base_time - 5.minutes) < @question.expired_at
      expect(distance_of_time_in_words(@question.expired_at - Time.now.utc)).to eq("about 1 month")
    end

    it "must set expired time to 1 day from now" do
      @question.expiration_id = "1 Day"
      @question.save
      @question.update_status_with_expired_at
      expect(distance_of_time_in_words(@question.expired_at - Time.now.utc)).to eq("1 day")
      # base_time = eval(@question.expiration_id.strip.downcase.gsub(/\s+/, ".")).from_now
      # start_boundry = (base_time - 5.minutes) < @question.expired_at
      # end_bound = (base_time - 5.minutes) < @question.expired_at
      # expect(start_boundry).to eq(true)
      # expect(end_bound).to eq(true)
    end

    it "must set expired time to 1 year from now" do
      @question.expiration_id = "1 Year"
      @question.save
      @question.update_status_with_expired_at
      expect(distance_of_time_in_words(@question.expired_at - Time.now.utc)).to eq("about 1 year")
      # base_time = eval(@question.expiration_id.strip.downcase.gsub(/\s+/, ".")).from_now
      # start_boundry = (base_time - 5.minutes) < @question.expired_at
      # end_bound = (base_time - 5.minutes) < @question.expired_at
      # expect(start_boundry).to eq(true)
      # expect(end_bound).to eq(true)
    end
  end

  describe "#question_send_sms" do
    it "must change question status" do
      @question.status == "Inactive"
      @question.save
      expect(@question.status).to eq("Active")
    end
  end

  describe "#qrcode_status_update" do
    it "must update qrcode and change status to active" do
      @question.status == "Inactive"
      @question.save
      @question.qrcode_status_update
      expect(@question.status).to eq("Active")
    end
  end

  describe "#get_email_list" do
=begin
    it "must get the email list of shared question" do
      @question.save
      params = {
        id: @question.id
      }
      email_list = Question.get_email_list(@user, params, "abc@def.ghi")
      expect(email_list).to eq([])
    end
=end
  end

  describe "#inactive_question_expire" do
    it "must set expires_at depending on expiration_id" do
      @question.expired_at = nil
      @question.expiration_id = "1 Year"
      @question.save
      expect(@question.inactive_question_expire).to eq(365) # actually there is a bug, that does not calculate year properly
    end
  end

  # describe "#wordcloud_responses" do
  #   it "must array of words orString" do
  #    @question.save
  #     params = {
  #       word: "a",
  #       page: 1
  #     }
  #     first_word = Question.wordcloud_responses(params, @user).first
  #     expect(first_word.class).to eq(String)
  #   end
  # end

  describe "#recent_activity" do
    # it "must throw an array of question for users recent activity" do
    #   result = Question.recent_activity(@user, @question.category_type_id, nil, nil, nil, 0, 10)
    #   expect(result).to eq([@question])
    # end
  end
end
