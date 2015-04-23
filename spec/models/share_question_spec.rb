require "spec_helper"

describe ShareQuestion do
#~ include SolrSpecHelper

  before(:each) do
    #~ solr_setup
    @user = FactoryGirl.create(:user, :default_biz_user)
    @share_question = FactoryGirl.create(:share_question, user: @user, email_address: @user.email)
  end

  it { should belong_to(:user) }

  describe "self.find_user_email" do
    it "must say user has been found when right credentials are given" do
      user_id = @user.id
      social_id = @share_question.social_id
      provider = @share_question.provider
      user_email = @user.email
      user_found = ShareQuestion.find_user_email(user_id, social_id , provider, user_email)
      expect(user_found).to eq(true)
    end
  end

  describe "self.shared_users_count" do
    it "must get the count of shared questions by the user via the provider" do
      user = @user
      provider = @share_question.provider
      count = ShareQuestion.shared_users_count(user, provider)
      expect(count).to eq(1) # because we have created just one share question
    end

    it "count shoule be zero when wrong provider is given" do
      user = @user
      provider = "Diaspora"
      count = ShareQuestion.shared_users_count(user, provider)
      expect(count).to eq(0) # because we have created just one share question
    end

    it "count shoule be zero when wrong user is given" do
      user = FactoryGirl.create(:user, :default_user) # this is not the one who has shared the question
      provider = @share_question.provider
      count = ShareQuestion.shared_users_count(user, provider)
      expect(count).to eq(0) # because we have created just one share question
    end
  end

  describe "self.shared_users_count" do
    it "must return shared user count as 1" do
      user = @user
      provider = @share_question.provider
      count = ShareQuestion.shared_users_count(user,provider)
      expect(count).to eq(1)
    end
  end

  describe "self.api_share_question_create(params)" do
    it "must create a share question" do
      ShareQuestion.delete_all
      params = {
        email: "mail@mail.com",
        provider: "Email",
        social_id: "Twitter",
        social_token: "someToken",
        user_id: @user.id,
        user_name: "Bob",
        user_profile_image: "/images/profile.png"
      }
      ShareQuestion.api_share_question_create(params)
      expect(ShareQuestion.count).to eq(1)
    end
  end

  #~ describe "self.user_social_setting_info" do
  #~ it 'finds the user shared question info info',:solr => true do
   #~ user = @user
   #~ question = @share_question
   #~ result = ShareQuestion.user_social_setting_info(user)
   #~ expect(result[:twitter]).not_to be_empty
  #~ end
 #~ end

  describe "self.voice_call" do
    # how to test this using rspec? Twilio-rspec?
  end
end