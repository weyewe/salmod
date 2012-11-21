class ServiceItem < ActiveRecord::Base
  attr_accessible  :sales_entry_id , :service_id 
  has_many :employees, :through => :service_subcriptions 
  has_many :service_subcriptions 
  
  belongs_to :sales_entry 
  belongs_to :service 
  
  # only 1 employee per service 
  def add_employee_participation( employee ) 
    current_subcriptions = self.service_subcriptions 
    puts "TOTal number of employee is #{self.employees.count  }"
    puts "total number of service subcriptions is #{current_subcriptions.count}"
     
    puts "Gonna destroy shite\n"*5
    if current_subcriptions.length != 0  
      current_subcriptions.each do |x|
        puts "3321 destroying, employee id is #{x.employee_id}"
        x.destroy 
      end
    end
    
    puts "Gonna create service subcription "
    ServiceSubcription.create :employee_id => employee.id, :service_item_id => self.id 
  end
  
  def selected_employee
    ServiceSubcription.find(:first, :conditions => {
      :service_item_id => self.id
    }).employee 
  end
  
  
  def delete
    self.is_deleted = true
    self.save 
  end
end
