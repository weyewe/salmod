class ScrapItem < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :stock_mutations 
  
  def self.create_scrap( employee, item, quantity) 
    
    new_scrap_item = ScrapItem.new 
    new_scrap_item.item_id = item.id 
    new_scrap_item.quantity = quantity 
    new_scrap_item.creator_id = employee.id 
    
    
    if item.is_deleted?  
      new_scrap_item.errors.add(:item_id , "Invalid Item" ) 
      return new_scrap_item
    end
    
    if quantity <= 0 or quantity > item.ready 
      new_scrap_item.errors.add(:quantity , "Invalid Quantity. Setidaknya 1 dan tidak lebih dari #{item.ready}"
      return new_scrap_item
    end
    
    new_scrap_item.save 
    
    ActiveRecord::Base.transaction do 
      StockMutation.deduct_ready_stock_add_scrap_item(
              employee, new_scrap_item
            ) 
    end
    
    return new_scrap_item 
  end
  
  def self.first_available_stock(item) 
    # FOR FIFO 
    # we will replace the first item entering scrap 
    ScrapItem.where(:is_finished => false, :item_id => item.id ).order("created_at ASC").first 
  end
  
  def unexchanged_quantity
    self.quantity - self.exchanged_quantity
  end
  
  def exchange_scrap( quantity  )
    self.exchanged_quantity += quantity
    self.save 
  end
end
