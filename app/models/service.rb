class Service < ActiveRecord::Base
  attr_accessible :name 
  has_one :sales_entry, :through => :service_item
  has_one :service_item
  
  validates_presence_of :name 
end
