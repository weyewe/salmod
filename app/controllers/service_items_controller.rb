class ServiceItemsController < ApplicationController
  
  def service_done_by_employee
    @employee = Employee.find_by_id params[:employee_id]
    @service_items = @employee.confirmed_services.joins(:service,  :sales_entry => [:sales_order] )
  end
end
