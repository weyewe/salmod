class Item < ActiveRecord::Base
  attr_accessible :name
  has_many :stock_entry 
  
=begin
  INITIAL MIGRATION 
=end 
  
  
end
