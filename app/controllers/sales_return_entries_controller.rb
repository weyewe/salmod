class SalesReturnEntriesController < ApplicationController
  def new 
    @sales_return = SalesReturn.find_by_id params[:sales_return_id]
    
    
    add_breadcrumb "Create Sales Return", 'new_sales_return_url'
    set_breadcrumb_for @sales_return, 'new_sales_return_sales_return_entry_url' + "(#{@sales_return.id})", 
                "#{@sales_return.code}"
  end
  
  def generate_sales_return_entry_add_product_form
    @item =  Item.find_by_id params[:selected_item_id]
    @sales_return = SalesReturn.find_by_id params[:sales_return_id]
    @new_object = SalesReturnEntry.new
  end
  
  def create
    @sales_return = SalesReturn.find_by_id params[:sales_return_id]
    @item = Item.find_by_id params[:item_id]
    @quantity = params[:sales_return_entry][:quantity].to_i
    @reimburse_price_per_piece =  BigDecimal( params[:sales_return_entry][:reimburse_price_per_piece] )
    
    @has_past_item =  @sales_return.has_sales_return_entry_for_item?(@item) 
    
    
    @sales_return_entry =   @sales_return.add_sales_return_entry_item( @item,    
                                                        @quantity, 
                                                        @reimburse_price_per_piece )
                          
    @has_no_errors  = @sales_return_entry.errors.messages.length == 0
  end
  
end
