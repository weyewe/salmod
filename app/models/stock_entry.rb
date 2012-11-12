class StockEntry < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :item
  has_many :stock_deductions 
  
  def available_quantity  
    quantity - used_quantity 
  end
  
  def update_usage(served_quantity) 
    self.used_quantity += served_quantity  
    if self.used_quantity == self.quantity
      self.is_finished = true 
    end
    
    self.save 
    # update the item summary 
    
    item = self.item 
    item.ready -= served_quantity 
    item.save 
    
    return self  
  end

  def self.first_available_stock
    # FOR FIFO 
    StockEntry.where(:is_finished => false ).order("created_at ASC").first 
  end
end
