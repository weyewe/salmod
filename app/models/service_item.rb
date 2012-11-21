class ServiceItem < ActiveRecord::Base
  attr_accessible :employee_id, :service_item_id, :sales_entry_id , :service_id 
  has_many :employees, :through => :service_subcriptions 
  has_many :service_subcriptions 
  
  belongs_to :sales_entry 
  belongs_to :service 
  
  
  def add_employee_participation( employee ) 
    current_subcription = ServiceSubcription.where :service_item_id => self.id , :employee_id => employee.id 
    if current_subcription.length == 0 
      ServiceSubcription.create :employee_id => employee.id, :service_item_id => self.id
    end
  end
  
  def selected_employee
    self.employees.first 
  end
  
  
  def delete
    self.is_deleted = true
    self.save 
  end
end
