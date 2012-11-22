class SalesOrdersController < ApplicationController
  
  def new
    @new_object = SalesOrder.new 
    @pending_confirmation_sales_orders = SalesOrder.where(:is_confirmed => false, :is_deleted => false ).order("created_at ASC")
  end
  
  
  def create
    @vehicle = Vehicle.find_by_id params[:sales_order][:vehicle_id]
    @customer = Customer.find_by_id params[:sales_order][:customer_id]
    @new_object = SalesOrder.create_sales_order( current_user, @customer, @vehicle )
    
    @errors =  @new_object.errors.messages
    
    @errors.each do |error|
      error.each do |x|
        puts x
      end
    end
    
     
    @has_no_errors  = @errors.length == 0
    
    puts "Middle Total errors: #{@errors.length}"
    
    if  @has_no_errors # don't call instance variable .valid? << it will kick out all the errors 
      puts "the object is valid\n"*10
      redirect_to new_sales_order_sales_entry_url(@new_object)
      return 
    else
      puts "There is error\n"*10
      puts "Last Total errors: #{@errors.length}"
      @pending_confirmation_sales_orders = SalesOrder.where(:is_confirmed => false, :is_deleted => false ).order("created_at ASC")
      render :file => "sales_orders/new"
      return 
    end
  end
   
  
  def confirm_sales_order
    @sales_order = SalesOrder.find_by_id params[:sales_order_id]
    # add some defensive programming.. current user has role admin, and current_user is indeed belongs to the company 
    # @sales_order.confirm_sales( current_user  ) 
 
  end
  
  def delete_sales_order
    
    
    redirect_to new_sales_order_url 
  end
   
  
end
