class Listener < ActiveRecord::Base
  #attr_protected
  belongs_to :user
  scope :fetch_listener, lambda { |id| where('user_id = ? ', id) }
end
