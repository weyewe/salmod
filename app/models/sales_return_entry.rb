class SalesReturnEntry < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :sales_return 
  belongs_to :sales_entry
  validates_presence_of :sales_return_id, :sales_entry_id, :quantity, :reimburse_price_per_piece
  
  validate :no_duplicate_sales_return_entry, 
            :quantity_less_than_or_equal_purchased_quantity,
            :non_negative_reimbursement_price
  
  def no_duplicate_sales_return_entry 
     
    sales_entry = self.sales_entry 
    item = sales_entry.item 
    if not sales_entry.nil? and self.any_duplicate_sales_return_entry? #  or sales_entry.nil?
      errors.add(:quantity , "No duplicate sales return for item #{item.name}" ) 
    end 
  end
  
  def any_duplicate_sales_return_entry?
    sales_entry = self.sales_entry
    item = sales_entry.item 
    sales_return = self.sales_return 
    
    sales_return.duplicate_sales_return_entry_for_item?(item)
  end
  
  def quantity_less_than_or_equal_purchased_quantity
    sales_return = self.sales_return
    item  = self.sales_entry.item 
    if not quantity.present? or quantity <= 0 or quantity > sales_return.max_returnable_for(item)
      errors.add(:quantity , "Quantity must be more than 1 and less than  #{sales_return.max_returnable_for(item)}" ) 
    end
  end
  
  def non_negative_reimbursement_price
    if self.reimburse_price_per_piece < BigDecimal('0')
      errors.add(:reimburse_price_per_piece , "Pengembalian uang tidak boleh negative" ) 
    end
  end
  
  
  
  
  
  
  
  
  
  
  
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
  
  # def recover_stock(employee)
  #   pending_recovery_quantity = self.quantity 
  #   
  #   sales_entry = self.sales_entry
  #   sales_order = sales_entry.sales_order 
  #    
  #   
  #   
  #   StockMutation.where(
  #     :source_document_entry_id  =>  sales_entry.id  ,
  #     :source_document_id  =>  sales_order.id  ,
  #     :source_document_entry     =>  sales_entry.class.to_s,
  #     :source_document    =>  sales_order.class.to_s,
  #     :mutation_case      => MUTATION_CASE[:sales_order],
  #     :mutation_status => MUTATION_STATUS[:deduction]
  #   ).order("created_at DESC").each do |stock_mutation|
  #     
  #     stock_entry = stock_mutation.stock_entry 
  #     deducted_quantity = stock_mutation.quantity
  #     
  #     quantity_to_be_recovered =  0 
  #     
  #     if deducted_quantity >= pending_recovery_quantity
  #       # it means this is the last stock_entry to be recovered
  #       quantity_to_be_recovered = pending_recovery_quantity
  #     else
  #       quantity_to_be_recovered = deducted_quantity
  #     end
  #     
  #     stock_entry.recover_usage(quantity_to_be_recovered) 
  #     pending_recovery_quantity -= quantity_to_be_recovered 
  #     
  #     StockMutation.create(
  #       :quantity            => quantity_to_be_recovered  ,
  #       :stock_entry_id      =>  stock_entry.id ,
  #       :creator_id          =>  employee.id ,
  #       :source_document_entry_id  =>  self.id  ,
  #       :source_document_id  =>  self.sales_return_id  ,
  #       :source_document_entry     =>  self.class.to_s,
  #       :source_document    =>  self.sales_return.class.to_s,
  #       :mutation_case      => MUTATION_CASE[:sales_return],
  #       :mutation_status => MUTATION_STATUS[:addition],
  #       :item_id => stock_entry.item_id
  #     )
  #   end
  #   
  #     
  # end
  #  
  # 
   
  
  
end
