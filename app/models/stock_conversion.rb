class StockConversion < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :conversion_entries
  
  def self.active_stock_conversions
    self.where(:is_deleted => false).order("created_at DESC")
  end
  
  def self.create_one_to_one( employee, source_item, target_item, quantity ) 
    new_stock_conversion = StockConversion.new 
    
    
    if source_item.nil? or target_item.nil? or not quantity.present?
      new_stock_conversion.errors.add(:source_item_id , "Tidak boleh kosong" ) 
      new_stock_conversion.errors.add(:target_item_id , "Tidak boleh kosong" ) 
      new_stock_conversion.errors.add(:target_quantity , "Tidak boleh kosong" ) 
      return new_stock_conversion
    end
    
    # a.errors[:name]
    if source_item.id == target_item.id or source_item.is_deleted? or target_item.is_deleted? 
      new_stock_conversion.errors.add(:source_item_id , "Source Item dan Target Item tidak boleh sama" ) 
      return new_stock_conversion
    end
    
    if quantity <= 0 
      new_stock_conversion.errors.add(:target_quantity , "Quantity harus setidaknya 1" ) 
      return new_stock_conversion
    end
    
    new_stock_conversion.conversion_status = CONVERSION_STATUS[:disassembly] 
    
    
    new_stock_conversion.save 
    new_stock_conversion.code ='SC/' + 
                                "#{new_stock_conversion.id}/" +  
                                "#{source_item.id}/" + 
                                "#{target_item.id}/" +
    
    new_stock_conversion.save 
     
    new_stock_conversion.create_conversion_entry( source_item, 1 , STOCK_CONVERSION_ENTRY_STATUS[:source] ) 
    new_stock_conversion.create_conversion_entry( target_item, quantity , STOCK_CONVERSION_ENTRY_STATUS[:target] ) 
  end
  
  def create_source_conversion_entry( item, quantity, status )
    new_conversion_entry = ConversionEntry.new 
    new_conversion_entry.stock_conversion_id = self.id 
    new_conversion_entry.item_id = item.id 
    new_conversion_entry.quantity = quantity 
    new_conversion_entry.entry_status = status 
    new_conversion_entry.save  
  end
  
  
end