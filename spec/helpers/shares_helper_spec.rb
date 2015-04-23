require "spec_helper"

describe SharesHelper do
	
  describe "#email_content_trim" do
    it "get email content trim" do
      helper.email_content_trim("Email content here").should_not be_blank
    end
  end
	
end