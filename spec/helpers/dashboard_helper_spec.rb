require "spec_helper"

describe DashboardHelper do
  describe "#get_view_percentage" do
    it "must return right percentage value" do
      view_percentage = helper.get_view_percentage(50, 100)
      view_percentage.should eql 50
    end
    it "must return right percentage value" do
      view_percentage = helper.get_view_percentage(50, 0)
      view_percentage.should eql 0
    end    
  end

  describe "#male_female_percentage" do
    view = {
      "male" => 60,
      "female" => 40
    }

    response = {
      "male" => 47,
      "female" => 162
    }
    it "must return right male count" do
      ans = helper.male_female_percentage(view, response, "male")
      ans.should eql 107
    end

    it "must return right female count" do
      ans = helper.male_female_percentage(view, response, "female")
      ans.should eql 202
    end
    view1 = {
      "male" => 0,
      "female" => 0
    }

    response1 = {
      "male" => 0,
      "female" => 0
    }
    it "must return right male count as zero" do
      ans = helper.male_female_percentage(view1, response1, "male")
      ans.should eql 0
    end

    it "must return right female count as zero" do
      ans = helper.male_female_percentage(view1, response1, "female")
      ans.should eql 0
    end    
  end

  # describe "#get_location_view_count_percentage" do
  #   it "must return right view count percentage" do
  #     view_count = 80
  #     response_count = 50
  #     ans = helper.get_location_view_count_percentage(view_count, response_count)
  #     ans.should eql 62.5
  #   end
  # end

  describe "#fetch_slug" do
    it "must get the question slug" do
      @user = FactoryGirl.create(:user, :default_biz_user)
      question = FactoryGirl.create(:question, :year_wise_expire, :user_id => @user.id)
      slug = helper.fetch_slug question.id
      slug.should eql question.slug
    end
  end

  # describe "#gender_percentage" do
  #   male_count = 56
  #   female_count = 72
  #   total_female_view = 25
  #   total_female_response = 25
  #   total_male_view = 25
  #   total_male_response =25
  #   it "should return right male percentage" do
  #     gender = "male"
  #     percentage = helper.gender_percentage(male_count,female_count,gender,total_female_view,total_female_response,total_male_view,total_male_response)
  #     percentage.should eql 56
  #   end

  #   it "should return right female percentage" do
  #     gender = "female"
  #     percentage = helper.gender_percentage(male_count,female_count,gender,total_female_view,total_female_response,total_male_view,total_male_response)
  #     percentage.should eql 72
  #   end
  # end

  describe "#previous_count" do
    it "must return previous count" do
      expect(helper.previous_count(14)).to eq(10)
    end

    it "must return right previous count" do
      expect(helper.previous_count(13)).to eq(7)
    end
  end

  describe "#get_plan_category_types" do
    it "get the plan category type" do
      user = FactoryGirl.create(:user, :default_biz_user)
      helper.get_plan_category_types(user).should eql("Feedback")
    end    
  end
  #~ describe "#demographics" do
    #~ it "must return right data structure for right input" do
      #~ # Very basic testing for datastructure
      #~ age_wise_view_count = [
       #~ {"male" => 5, "female" => 10},
        #~ {"male" => 5, "female" => 10},
       #~ {"male" => 5, "female" => 10},
       #~ {"male" => 5, "female" => 10},
       #~ {"male" => 5, "female" => 10},
       #~ {"male" => 5, "female" => 10},
       #~ {"male" => 5, "female" => 10},
        #~ {"male" => 5, "female" => 10}
      #~ ]

      #~ age_wise_response_count = [
        #~ {"male" => 5, "female" => 10},
        #~ {"male" => 5, "female" => 10},
       #~ {"male" => 5, "female" => 10},
       #~ {"male" => 5, "female" => 10},
       #~ {"male" => 5, "female" => 10},
       #~ {"male" => 5, "female" => 10},
       #~ {"male" => 5, "female" => 10},
        #~ {"male" => 5, "female" => 10}
      #~ ]
      #~ result = helper.demographics_calculation(age_wise_view_count, age_wise_response_count)
      #~ expect(result.class).to eq(Hash)
    #~ end
  #~ end
end