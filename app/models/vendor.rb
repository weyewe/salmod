class Vendor < ActiveRecord::Base
  attr_accessible :name, :contact_person, :phone, :mobile , :email, :bbm_pin, :address
  
  validates_presence_of :name 
  validates_uniqueness_of :name 
  
  
  
end
