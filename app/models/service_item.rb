class ServiceItem < ActiveRecord::Base
  attr_accessible :employee_id, :service_id, :sales_entry_id 
  has_many :employees, :through => :service_subcriptions 
  has_many :service_subcriptions 
  
  belongs_to :sales_entry 
  belongs_to :service 
  
  
  def add_employee_participation( employee ) 
    current_subcription = ServiceSubcription.where :service_id => self.service_id , :employee => employee.id 
    if current_subcription.nil?
      ServiceSubcription.create :employee_id => employee.id, :service_id => self.service_id
    end
  end
end
