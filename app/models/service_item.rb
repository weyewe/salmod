class ServiceItem < ActiveRecord::Base
  attr_accessible :employee_id, :service_item_id, :sales_entry_id , :service_id 
  has_many :employees, :through => :service_subcriptions 
  has_many :service_subcriptions 
  
  belongs_to :sales_entry 
  belongs_to :service 
  
  # only 1 employee per service 
  def add_employee_participation( employee ) 
    current_subcriptions = ServiceSubcription.where :service_item_id => self.id , :employee_id => employee.id 
     
    if current_subcriptions.length != 0  
      current_subcriptions.each do |x|
        x.destroy 
      end
    end
    
    ServiceSubcription.create :employee_id => employee.id, :service_item_id => self.id
  end
  
  def selected_employee
    self.employees.first 
  end
  
  
  def delete
    self.is_deleted = true
    self.save 
  end
end
