class SalesReturnEntry < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :sales_return 
  belongs_to :sales_entry
  validates_presence_of :sales_return_id, :sales_entry_id, :quantity, :reimburse_price_per_piece
  
  def update_item( quantity, reimburse_price_per_piece)
    return nil if self.sales_return.is_confirmed?
    sales_entry = self.sales_entry
    item = sales_entry.item 
     
    if not quantity.present? or quantity <=  0 or quantity > sales_entry.max_returnable_quantity
      self.errors.add(:quantity , "Quantity harus setidaknya 1 dan lebih kecil dari #{sales_entry.max_returnable_quantity}" ) 
      return self
    end
     
    if not reimburse_price_per_piece.present? or reimburse_price_per_piece <=  BigDecimal('0')
      self.errors.add(:reimburse_price_per_piece , "Uang pengembalian harus lebih besar dari 0 rupiah" ) 
      return self
    end
    
    self.quantity = quantity 
    self.reimburse_price_per_piece = reimburse_price_per_piece
    self.total_reimburse_price = quantity  * reimburse_price_per_piece 
    self.save
    
    return self
  end
  
  def delete
    self.is_deleted = true 
    self.save
  end
  
  def recover_stock(employee)
    pending_recovery_quantity = self.quantity 
    
    sales_entry = self.sales_entry
    sales_order = sales_entry.sales_order 
     
    
    
    StockMutation.where(
      :source_document_entry_id  =>  sales_entry.id  ,
      :source_document_id  =>  sales_order.id  ,
      :source_document_entry     =>  sales_entry.class.to_s,
      :source_document    =>  sales_order.class.to_s,
      :mutation_case      => MUTATION_CASE[:sales_order],
      :mutation_status => MUTATION_STATUS[:deduction]
    ).order("created_at DESC").each do |stock_mutation|
      
      stock_entry = stock_mutation.stock_entry 
      deducted_quantity = stock_mutation.quantity
      
      quantity_to_be_recovered =  0 
      
      if deducted_quantity >= pending_recovery_quantity
        # it means this is the last stock_entry to be recovered
        quantity_to_be_recovered = pending_recovery_quantity
      else
        quantity_to_be_recovered = deducted_quantity
      end
      
      stock_entry.recover_usage(quantity_to_be_recovered) 
      pending_recovery_quantity -= quantity_to_be_recovered 
      
      StockMutation.create(
        :quantity            => quantity_to_be_recovered  ,
        :stock_entry_id      =>  stock_entry.id ,
        :creator_id          =>  employee.id ,
        :source_document_entry_id  =>  self.id  ,
        :source_document_id  =>  self.sales_return_id  ,
        :source_document_entry     =>  self.class.to_s,
        :source_document    =>  self.sales_return.class.to_s,
        :mutation_case      => MUTATION_CASE[:sales_return],
        :mutation_status => MUTATION_STATUS[:addition],
        :item_id => stock_entry.item_id
      )
    end
    
      
  end
   
  
   
  
  
end
