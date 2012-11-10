class SalesEntry < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :sales_order 
  belongs_to :maintenance 
end
