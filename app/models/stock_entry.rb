class StockEntry < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :item_id 
end
