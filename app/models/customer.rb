class Customer < ActiveRecord::Base
  attr_accessible :name, :contact_person, :phone, :mobile , :email, :bbm_pin, :address
  has_many :vehicles 
  
  validates_presence_of :name 
  validates_uniqueness_of :name
end
