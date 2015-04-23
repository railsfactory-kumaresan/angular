class Tenant < ActiveRecord::Base
  belongs_to :user
  has_many :questions
  scope :get_tenant_list, lambda { |user| where('client_id=?', user.parent_id == 0 ? user.id : user.parent_id) }
  scope :get_active_tenant_list, lambda { |user| where('is_active =? and client_id=?',true,(user.parent_id == 0 ? user.id : user.parent_id)) }

  after_create :map_tenant_with_client

  validates :name, :presence => {:message => "Please enter tenant name."}
  validates :name, :uniqueness => {:scope => :client_id, :message => "Tenant already exists."}
  #validates_format_of :redirect_url, :with => /\A^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$\z/, message:"Please enter valid url."

  def map_tenant_with_client
      ExecutiveTenantMapping.create(user_id: self.client_id, tenant_id: self.id, is_active: true)
  end

  def self.change_tenant_status(params)
    tenant = where(id: params[:tenant_id]).first
    status = params[:is_active] == "true" ? 0 : 1
    tenant.update_attributes(is_active: status)
    return tenant.is_active
  end

  def self.get_tenant(user_id)
    if user_id.parent_id.to_i != 0 &&  !user_id.parent_id.blank?
      p tenant_o = ''
      executive_te = ExecutiveTenantMapping.where(user_id: user_id.id).collect{|i|i.tenant_id}.join(",")
      tenant_o = (!executive_te.blank? ?  tenant_o + ",#{user_id.tenant_id.to_s}" :"#{user_id.tenant_id.to_s}")
      tenant = Tenant.where(id:tenant_o)
    else
       tenant = where(client_id: user_id.id)
    end
    return tenant
  end
end
