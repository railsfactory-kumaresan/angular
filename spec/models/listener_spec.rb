require "spec_helper"

describe Listener do
   describe "#Association" do
		it { should belong_to(:user) }
	 end
end