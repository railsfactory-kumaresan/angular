class Role < ActiveRecord::Base
 has_many :permissions
 has_one :user
 validates :name, :presence => { :message => "Role name shouldn't be blank" }
 validates :name, :uniqueness => {:scope => :user_id,:message=>"Role already exists"}
 DEFAULT_ROLES = DEFAULTS['internal_roles']
 TENANT_ROLES = DEFAULTS['tenant_roles']


def self.get_role(user)#to do - need to modify for multi tenant
  plan_name = PricingPlan.find_pricing_plan(user.business_type_id).first.plan_name
  plan_name.include?("#{DEFAULTS['signup_plan_individual']}") ? where(name: DEFAULTS['signup_role_individual']).first.id : where(name: DEFAULTS['signup_role_other']).first.id
end

def self.get_all_roles
 where("name not like ? and user_id is NULL","%#{DEFAULTS['inquirly_role']}%")
end

def self.default_roles_with_custom_roles(user)
  where("user_id is NULL and name NOT IN (?)",Role::DEFAULT_ROLES) + where(user_id: user.parent_id == 0 ? user.id : user.parent_id)
end

def self.get_tenant_roles(current_user)
 user_id = current_user.parent_id == 0 ? "#{current_user.id}" : "#{current_user.parent_id}"
 roles= where("user_id = ? or user_id is null",user_id).where.not(name: Role::DEFAULT_ROLES)
end

def self.get_role_by_id(id)
	self.where("id =?",id).first
end

end
