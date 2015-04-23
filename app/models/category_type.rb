class CategoryType < ActiveRecord::Base
  #attr_accessible :category_name
  has_many :questions
     has_many :pricing_plans, :through => :pricing_category_types
   has_many :pricing_category_types


  # def self.find_categories(business_type_id)
  # 	if business_type_id == 1
  #     where("id =?", 1)
  #   else
  #     self.all
  #   end
  # end

  def self.find_category(id)
    self.where("id =?",id)
  end

 def self.get_categories(user)
  ids = self.get_category_type_ids(user)
  self.find_categories(ids)
 end

 def self.get_category_type_ids(user)
   # Multitenant ClientSetting
   user = user.parent_id != 0 && user.parent_id != nil ? User.where(id: user.parent_id).first : user
   ClientSetting.get_column_value("categories",user)
 end

 def self.find_categories(ids)
  where("id in (?)",ids)
 end

end