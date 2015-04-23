class PricingCategoryType < ActiveRecord::Base
	belongs_to :pricing_plan
	belongs_to :category_type
	after_save :reload_pricing_plan_initializer
	private
def reload_pricing_plan_initializer
   ActiveSupport::Dependencies.load_file "config/initializers/pricing_plan.rb"
end

end
