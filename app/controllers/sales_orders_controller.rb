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
    
    
    
    
    
    puts "Total errors: #{@errors.length}"
    @new_object.errors.each{|attr,err| puts "#{attr} - #{err}" }
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
  
  # will create the sales order
  def generate_sales_order
  end
  
  def confirm_sales_order
  end
   
  
end
