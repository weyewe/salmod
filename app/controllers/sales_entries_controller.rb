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
  
end
