class Vehicle < ActiveRecord::Base 
  attr_accessible :id_code 
  belongs_to :customer 
  
  has_many :maintenances 
  # has_many :ownership_mutation 
  
  validates_presence_of :id_code
end
