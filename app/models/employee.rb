class Employee < ActiveRecord::Base
  attr_accessible :name, :mobile_phone , :address 
  has_many :service_items, :through => :service_subcriptions
  has_many :service_subcriptions 
  
  after_create :add_employee_code
  
  
  def add_employee_code
    year = DateTime.now.year 
    month = DateTime.now.month  
    total_employee_created_this_month = Employee.where(:year => year.to_i, :month => month.to_i).count  

    code =  'EM/' + year.to_s + '/' + 
                        month.to_s + '/' + 
                        (total_employee_created_this_month + 1 ).to_s
                        
    self.year = year 
    self.month = month 
    self.code = code
    self.save 
  end
end
