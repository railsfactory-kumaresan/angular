class PricingPlan < ActiveRecord::Base
after_create :assign_business_type_id
after_save :reload_pricing_plan_initializer
has_many :pricing_category_types
has_many :category_types, :through => :pricing_category_types

PRICING_PLAN_EXD_COLUMNS = ["id","created_at","updated_at","plan_name","expired_date"]
PRICING_PLAN_COLUMNS = self.column_names if self.table_exists?

def self.define_pricing_plans
@pricing_plans = {}
plans = self.get_all_plans
plans.find_each do |plan|
PRICING_PLAN_COLUMNS.each do |column|
 @pricing_plans.merge!({"#{plan.plan_name}:#{column}" => plan.send("#{column}") })  unless PRICING_PLAN_EXD_COLUMNS.include?(column)
end
 @pricing_plans.merge!({"#{plan.plan_name}:category_types" => plan.category_types.map(&:id)})
end
return @pricing_plans
end

def self.get_all_plans
  self.where("expired_date is null")
end

def self.list_all_plans
  self.all
end

def self.get_settings_plans
  self.where("expired_date is null and id > ?",1)
end


#order_by_amount, start from large amount
def self.order_by_amount
  self.get_all_plans.order("amount DESC")
end

#order_by_amount, start from small amount
def self.order_by_amount_asc
  self.get_all_plans.order("amount ASC")
end

#change plan checking
def self.change_plan_check(current_plan_id,new_plan_id)
  current_plan = self.find_by_business_type_id(current_plan_id)
  new_plan = self.find_by_business_type_id(new_plan_id)
    if current_plan.id == new_plan.id
    return "current_plan"
  elsif new_plan.amount > current_plan.amount
    return "upgrade"
  elsif  new_plan.amount < current_plan.amount
    return "downgrade"
  end
end

def self.find_pricing_plan(id)
  where(id: id)
end

private
def assign_business_type_id
   self.update_attribute("business_type_id",self.id)
end

def reload_pricing_plan_initializer
   ActiveSupport::Dependencies.load_file "config/initializers/pricing_plan.rb"
end

end