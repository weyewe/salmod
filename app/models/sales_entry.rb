class SalesEntry < ActiveRecord::Base
  attr_accessible :entry_id, :entry_case, :selling_price_per_piece, :quantity
  belongs_to :sales_order 
  belongs_to :maintenance 
   
  
  def update_total_sales_price 
    self.selling_price_per_piece *  self.quantity
  end
  
  def delete
    self.is_deleted = true 
    self.save 
  end
  
  def deduct_stock(employee)
    requested_quantity = self.quantity
    # if quantity > item.ready_quantity
    # return nil -> correct way: create indent request 
    # end 
    supplied_quantity = 0
    
    
     
    while supplied_quantity != requested_quantity
      # create stock entry to deduct it 
      unfulfilled_quantity = requested_quantity - supplied_quantity 
      
      stock_entry =  StockEntry.first_available_stock
      available_quantity = stock_entry.available_quantity 
      
      served_quantity = 0 
      if unfulfilled_quantity <= available_quantity 
        served_quantity = unfulfilled_quantity 
      else
        served_quantity = available_quantity 
      end
      
      stock_entry.update_usage(served_quantity) 
      supplied_quantity += served_quantity 
      
      StockDeduction.create(
        :quantity            => served_quantity  ,
        :stock_entry_id      =>  stock_entry.id ,
        :creator_id          =>  employee.id ,
        :source_document_entry_id  =>  self.id  ,
        :source_document_id  =>  self.sales_order_id  ,
        :source_document_entry     =>  self.class.to_s,
        :source_document    =>  self.sales_order.class.to_s,
        :deduction_case      => STOCK_DEDUCTION_CASE[:sales_order]
      )
       
    end 
  end
end
