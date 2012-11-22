class SalesEntry < ActiveRecord::Base
  attr_accessible :entry_id, :entry_case, :selling_price_per_piece, :quantity
  belongs_to :sales_order 
  belongs_to :maintenance 
  
  has_one :service_item 
  has_one :service, :through  => :service_item 
   
  
  def update_total_sales_price 
    self.total_sales_price = self.selling_price_per_piece *  self.quantity
    self.save 
  end
  
  def delete 
    return nil if self.sales_order.is_confirmed?
    
    self.is_deleted = true 
    self.save  
    
    if self.is_service?
      service_item = self.service_item
      service_item.delete 
    end
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
  
  def is_product?
    self.entry_case == SALES_ENTRY_CASE[:item]
  end
  
  def is_service?
    self.entry_case == SALES_ENTRY_CASE[:service]
  end
  
  def item
    if self.is_product?
      return Item.find_by_id self.entry_id
    else self.is_service?
      return Service.find_by_id self.entry_id
    end
  end
  
  
  def generate_service_item
    if self.entry_case != SALES_ENTRY_CASE[:service]
      return nil 
    end
    
    ServiceItem.create :service_id => self.entry_id, :sales_entry_id => self.id 
  end
  
  def add_employee( employee )
    if self.entry_case !=  SALES_ENTRY_CASE[:service]
      return nil 
    end
    
    
    service_item = self.service_item 
    service_item.add_employee_participation( employee )  
  end
  
=begin
  Sales Order Creation
=end
  def total_price
    self.quantity * self.selling_price_per_piece
  end
  
=begin
  UPDATE SALES ENTRY
=end
  def update_item(quantity, price_per_piece) 
    return nil if self.sales_order.is_confirmed?
     
    if not quantity.present? or quantity <=  0
      self.errors.add(:quantity , "Quantity harus setidaknya 1" ) 
      return self
    end
     
    if not price_per_piece.present? or price_per_piece <=  BigDecimal('0')
      self.errors.add(:selling_price_per_piece , "Harga jual harus lebih besar dari 0 rupiah" ) 
      return self
    end
    
    self.quantity = quantity 
    self.selling_price_per_piece = price_per_piece
    self.total_sales_price = quantity  * price_per_piece 
    self.save
    
    return self
  end
  
  
  def add_employee(employee)
    service_item = self.service_item 
    service_item.add_employee_participation( employee )
  end
  
  def update_service( price, employee ) 
    return nil if self.sales_order.is_confirmed?
    
    if not price.present? or price <=  BigDecimal('0')
      self.errors.add(:selling_price_per_piece , "Harga jual harus lebih besar dari 0 rupiah" ) 
      return self
    end
     
    self.selling_price_per_piece = price
    self.total_sales_price =price
    self.save
    
    if not employee.nil? and not employee.is_deleted 
      self.add_employee(employee) 
    end  
    
    return self 
  end
end
