class Feature < ActiveRecord::Base

def self.get_parent_features
 where(:parent_id => 0)
end

def sub_features
 Feature.where(:parent_id => self.id)
end

end

