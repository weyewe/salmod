class SalesEntriesController < ApplicationController
  def new 
    @sales_order = SalesOrder.find_by_id params[:sales_order_id]
    
    add_breadcrumb "Create Sales Order", 'new_sales_order_url'
    set_breadcrumb_for @group_loan, 'new_sales_order_sales_entry_url' + "(#{@sales_order.id})", 
                "#{@sales_order.code}"
  end
  
  def generate_sales_entry_add_product_form
    @item=  Item.find_by_id params[:selected_item_id]
    @sales_order = SalesOrder.find_by_id params[:sales_order_id]
    @new_object = SalesEntry.new 
    
     
  end
  
  
  # create item  sales entry # it can be service 
  def create
    @sales_order = SalesOrder.find_by_id params[:sales_order_id]
    @item = Item.find_by_id params[:item_id]
    @quantity = params[:sales_entry][:quantity].to_i
    @selling_price_per_piece =  BigDecimal( params[:sales_entry][:selling_price_per_piece] )
    
    @has_past_item =  @sales_order.has_sales_entry_for_item?(@item) 
    
    
    @sales_entry =   @sales_order.add_sales_entry_item( @item,    
                                                        @quantity, 
                                                        @selling_price_per_piece )
                          
    @has_no_errors  = @sales_entry.errors.messages.length == 0 
     
  end
  
end
