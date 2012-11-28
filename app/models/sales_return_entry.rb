class SalesReturnEntry < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :sales_return 
  belongs_to :sales_entry
  validates_presence_of :sales_return_id, :sales_entry_id, :quantity, :reimburse_price_per_piece
end
