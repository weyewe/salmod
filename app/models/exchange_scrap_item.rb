class ExchangeScrapItem < ActiveRecord::Base
  # attr_accessible :title, :body
  def self.create_exchange_scrap( employee, item, quantity) 
    
    new_ex_scrap_item = ExchangeScrapItem.new 
    new_ex_scrap_item.item_id = item.id 
    new_ex_scrap_item.quantity = quantity 
    new_ex_scrap_item.creator_id = employee.id 
    
    
    if item.is_deleted?  
      new_ex_scrap_item.errors.add(:item_id , "Invalid Item" ) 
      return new_ex_scrap_item
    end
    
    if quantity <= 0 or quantity > item.scrap 
      new_ex_scrap_item.errors.add(:quantity , "Invalid Quantity. Setidaknya 1 dan tidak lebih dari #{item.scrap}"
      return new_ex_scrap_item
    end
    
    new_ex_scrap_item.save 
    
    ActiveRecord::Base.transaction do 
      StockMutation.deduct_scrap_add_ready_stock(
              employee, new_ex_scrap_item
            ) 
    end
    
    return new_ex_scrap_item 
  end
end
