class SalesOrdersController < ApplicationController
  
  def new
    @new_object = SalesOrder.new 
    @pending_confirmation_sales_orders = SalesOrder.where(:is_confirmed => false, :is_deleted => false ).order("created_at ASC")
  end
  
  
  def create
    @vehicle = Vehicle.find_by_id params[:sales_order][:vehicle_id]
    @customer = Customer.find_by_id params[:sales_order][:customer_id]
    @new_object = SalesOrder.create_sales_order( current_user, @customer, @vehicle )
    
    if @new_object.valid? 
      redirect_to new_sales_order_sales_entry_url(@new_object)
    else
      render :file => "sales_orders/new"
      return 
    end
  end
  
  # will create the sales order
  def generate_sales_order
  end
  
  def confirm_sales_order
  end
   
  
end
