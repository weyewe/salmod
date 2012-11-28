class SalesReturn < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :sales_order
  has_many :sales_return_entries 
  validates_presence_of :sales_order_id 
  
  def self.create_sales_return( employee, sales_order )  
    a = SalesReturn.new
    year = DateTime.now.year 
    month = DateTime.now.month  
    total_sales_returns_created_this_month = SalesReturn.where(:year => year.to_i, :month => month.to_i).count  

    code =  'SR/' + year.to_s + '/' + 
                        month.to_s + '/' + 
                        (total_sales_returns_created_this_month + 1 ).to_s 
                        
    a.year = year
    a.month = month 
    a.sales_order_id = sales_order.id
    
    if sales_order.nil? or not sales_order.is_confirmed? 
      a.errors.add(:sales_order_id , "Sales invoice #{sales_order.code} invalid" ) 
      return a
    end
       
    
    a.creator_id = employee.id 
        
    a.code = code 
    a.save 
    return a 
  end
  
  
  def active_sales_return_entries
    self.sales_return_entries.where(:is_deleted => false ).order("created_at ASC")
  end
  
  
  def total_amount_to_be_reimbursed
    self.active_sales_return_entries.sum("total_return_price") - self.admin_fee
  end
  
end
