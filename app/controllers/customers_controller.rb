class CustomersController < ApplicationController
  def new
    @objects = Customer.active_customers
    @new_object = Customer.new 
  end
  
  def create
    # HARD CODE.. just for testing purposes 
    params[:customer][:town_id] = Town.first.id 
    @object = Customer.create( params[:customer] ) 
    if @object.valid?
      @new_object=  Customer.new
    else
      @new_object= @object
    end
    
  end
end
