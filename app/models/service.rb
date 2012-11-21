class Service < ActiveRecord::Base
  attr_accessible :name 
  has_one :sales_entry, :through => :service_item
  has_one :service_item
  
  validates_presence_of :name 
  
  def set_price(price)
    if price.nil? or price <= BigDecimal('0')
      return nil
    end
    
    self.recommended_selling_price = price
    self.save 
    return self 
  end
end
