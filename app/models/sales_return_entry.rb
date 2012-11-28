class SalesReturnEntry < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :sales_return 
  belongs_to :sales_entries 
end
