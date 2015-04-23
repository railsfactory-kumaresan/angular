require "spec_helper"

describe CountsStore do
  before(:each) {
    @user = FactoryGirl.create(:user,:default_biz_user)
		@question = FactoryGirl.create(:question, :user_id => @user.id, :expired_at => Time.now + 4.days, :expiration_id => "1 Month")
		@countsstore = FactoryGirl.create(:counts_store, question_id: @question.id)
  }
	
	describe "#find_for_increment" do
		 it "find the count store record" do
			result = CountsStore.find_for_increment(@question.id, @countsstore.vrtype, @countsstore.country, @countsstore.norm_date)
			expect(result).to eq(@countsstore)
		end
		 it "create the count store record" do
			result = CountsStore.find_for_increment(@question.id, @countsstore.vrtype, "", @countsstore.norm_date)
			expect(result).not_to eq(@countsstore)
		end		
	end
	
	describe "#find_counts_store" do
		 it "find the count store record" do
			result = CountsStore.find_counts_store(@question.id, @countsstore.vrtype, @countsstore.country, @countsstore.norm_date)
			expect(result.last).to eq(@countsstore)
		end
	end
	
	#~ describe "#get_counts" do
		 #~ it "get counts" do
			#~ params = {:from_date => "2014/11/12", :to_date => "2014/11/13"}
			#~ result = CountsStore.get_counts([@question.id], params, nil)
			#~ expect(result.last).to eq(@countsstore)
		#~ end
	#~ end

	describe "#get_counts_static_location" do
		 it "get counts static location" do
			params = {:from_date => "2014/11/12", :to_date => "2014/11/13"}
			result = CountsStore.get_counts_static_location([@question.id], params, nil)
			expect(result).to eq({})
		end
		 it "get counts static location without params" do
			result = CountsStore.get_counts_static_location([@question.id], {}, nil)
			expect(result["IN"]).to eq({"view"=>0})
		end		
	end	
	
	describe "#get_counts_static_chart" do
		 it "get counts static chart" do
			params = {:from_date => "2014/11/12", :to_date => "2014/11/13"}
			result = CountsStore.get_counts_static_chart([@question.id], params, nil)
			expect(result.last).to eq(nil)
		end
	end	
	
end		