# require 'active_support/concern'
# class BusinessCustomerInfo
#   module BusinessCustomerInfoSerach
#     extend ActiveSupport::Concern
#     included do
#       def self.collection_of_business_users(current_user_id)
# 				count = BusinessCustomerInfo.count
# 					@search = BusinessCustomerInfo.search do
# 						with(:user_id,current_user_id)
# 						paginate :page => 1, :per_page => count
# 					#~ facet :id
# 					#~ facet :customer_name
# 					#~ facet :email
# 					#~ facet :age
# 					#~ facet :mobile
# 					#~ facet :country
# 					#~ facet :city
# 					#~ facet :state
# 					#~ facet :area
# 					end
#       end
#     end
#   end
# end