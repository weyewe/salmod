class StockEntry < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :item
  has_many :stock_mutations 
  
  
  
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
  
  def recover_usage(quantity_to_be_recovered)
    self.used_quantity -= quantity_to_be_recovered 
     
    if self.used_quantity != self.quantity
      self.is_finished = false 
    end
    
    self.save 
    # update the item summary 
    
    item = self.item 
    item.ready += quantity_to_be_recovered 
    item.save 
    
    return self 
  end

  def self.first_available_stock(item) 
    # FOR FIFO 
    StockEntry.where(:is_finished => false, :item_id => item.id ).order("created_at ASC").first 
  end
  
  def stock_migration
    if self.entry_case == STOCK_ENTRY_CASE[:initial_migration]
      StockMigration.find_by_id self.source_document_id
    else
      return nil
    end
  end
end
