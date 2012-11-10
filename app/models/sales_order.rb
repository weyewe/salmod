class SalesOrder < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :maintenances 
  has_many :sales_entry  # can be service or item sold 
end
