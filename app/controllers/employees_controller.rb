class EmployeesController < ApplicationController
  
  
  def new 
    @objects = Employee.active_employees
    @new_object = Employee.new
  end
  
  def create
    
    @object = Employee.create(   params[:employee])
    
    
    if @object.valid?
      @new_object=  Employee.new
    else
      @new_object= @object
    end
  end
end
