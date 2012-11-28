class SalesReturnsController < ApplicationController
  def new
    @new_object = SalesReturn.new 
    @pending_confirmation_sales_returns = SalesReturn.
                                      where(:is_confirmed => false, :is_deleted => false ).order("created_at DESC")
    @confirmed_sales_returns = SalesReturn.
                    where(:is_confirmed => true, :is_deleted => false ).order("confirmed_datetime DESC").limit(10)
  end
  
  def create 
    
    @sales_order = SalesOrder.find_by_id params[:sales_return][:sales_order_id]
    @new_object = SalesReturn.create_sales_return( current_user, @sales_order  )
    
    @errors =  @new_object.errors.messages
    
     
    @has_no_errors  = @errors.length == 0
     
    if  @has_no_errors  
      redirect_to new_sales_return_sales_return_entry_url(@new_object)
      return 
    else 
      @pending_confirmation_sales_returns = SalesReturn.
                                        where(:is_confirmed => false, :is_deleted => false ).order("created_at DESC")
      @confirmed_sales_returns = SalesReturn.
                      where(:is_confirmed => true, :is_deleted => false ).order("confirmed_datetime DESC").limit(10)
      render :file => "sales_returns/new"
      return 
    end
  end
  
  
end
