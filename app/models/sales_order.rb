class SalesOrder < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :customer 
  has_many :maintenances 
  has_many :sales_entry  # can be service or item sold 
end
