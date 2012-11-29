# the class that will convert the stock, from item A to item B
# stock keeping-wise, it is working. How about the $$$ side of biz? not yet
# when item A is converted.. the item B's CoGS is added by item A COGS/ quantity 

# CAN'T BE DELETED? YEAh.. it can't 

class ConvertStock < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :stock_conversion
  
  # one to one is not recognized anymore over here. 
  # it is only @ the UI layer 
  def execute_conversion(employee) 
    # deduct all the source
    # add all the targets 
  end
  
end
