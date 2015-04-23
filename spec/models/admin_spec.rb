require "spec_helper"

describe Admin do
	it "table_name_prefix" do
		expect(Admin.table_name_prefix).to eq("admin_")
	end
end