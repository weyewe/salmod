class SalesOrder < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :customer 
  belongs_to :vehicle
  has_many :maintenances  # no, we don't go with the maintenance. stick with the MVP, willy! 
  has_many :sales_entries 
  
  # has_many :sales_entries, :through => :stock_entry_usages  # can be service or item sold 
  # has_many :stock_entry_usages
  
  # has_many :services, :through => :service_items 
  #   has_many :service_items 
  
  # validates_presence_of :is_registered_customer
  # validates_presence_of :is_registered_vehicle
  
  def self.create_sales_order( employee, customer, vehicle )  
    a = SalesOrder.new
    year = DateTime.now.year 
    month = DateTime.now.month  
    total_sales_orders_created_this_month = SalesOrder.where(:year => year.to_i, :month => month.to_i).count  

    code =  'SO/' + year.to_s + '/' + 
                        month.to_s + '/' + 
                        (total_sales_orders_created_this_month + 1 ).to_s 
                        
    a.year = year
    a.month = month 
    if not customer.nil?
      a.customer_id = customer.id   
    end
    
    if not vehicle.nil?
      a.vehicle_id = vehicle.id   
    end
    
    a.creator_id = employee.id 
        
    a.code = code 
    a.save 
    return a 
  end
  
  
  
  
  
  def active_sales_entries
    self.sales_entries.where(:is_deleted => false )
    
  end
  
  def sales_entry_for_item( item)
    self.sales_entries.find(:first, :conditions => {
      :entry_case => SALES_ENTRY_CASE[:item],
      :entry_id => item.id ,
      :is_deleted => false 
    })  
  end 
  
  def add_sales_entry_item(item,  quantity,   price_per_piece )
    past_item = self.sales_entry_for_item(item)   
    return past_item if not past_item.nil? 
    
    # rule for sales entry creation: max stock?  no indent?. just sell whatever we have now 
    # MVP minimum viable product 
    sales_entry = self.sales_entries.create(
      :entry_id => item.id ,   
      :entry_case => SALES_ENTRY_CASE[:item] ,
      :quantity => quantity , 
      :selling_price_per_piece => price_per_piece
    )
     
    sales_entry.update_total_sales_price  
  
    return sales_entry  
  end
  
  
  
  def add_sales_entry_service(service_object) 
    sales_entry = self.sales_entries.create(
      :entry_id => service_object.id ,   
      :entry_case => SALES_ENTRY_CASE[:service] ,
      :quantity => 1 , 
      :selling_price_per_piece => service_object.recommended_selling_price
    )
    
    sales_entry.generate_service_item 
  
    return sales_entry
  end
 
  def delete_sales_entry( sales_entry ) 
    SalesEntry.where(:id => sales_entry.id).each {|x| x.delete }
  end
  
  # on sales order confirm, deduct stock level 
  
  def confirm_sales( employee)  
    ActiveRecord::Base.transaction do
      
      self.active_sales_entries.each do |sales_entry|
        
        if sales_entry.entry_case  ==  SALES_ENTRY_CASE[:item]
          sales_entry.deduct_stock(employee)
        elsif sales_entry.entry_case  ==  SALES_ENTRY_CASE[:service]
          # sales_entry.confirm_service_appointment
        end
      end
      
      self.is_confirmed = true 
      self.confirmator_id = employee.id 
    end 
  end
  
  
end
