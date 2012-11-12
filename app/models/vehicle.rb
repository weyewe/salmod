class Vehicle < ActiveRecord::Base 
  attr_accessible :id_code 
  belongs_to :customer 
  has_many :sales_orders 
  
  has_many :maintenances  # 1 sales order is assumed to be 1 maintenance 
  # has_many :ownership_mutation 
  
  validates_presence_of :id_code
end
