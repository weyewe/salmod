class ConversionEntry < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :stock_conversion 
  
end
