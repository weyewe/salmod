class SalesReturnEntriesController < ApplicationController
  def new 
    @sales_return = SalesReturn.find_by_id params[:sales_return_id]
    
    
    add_breadcrumb "Create Sales Return", 'new_sales_return_url'
    set_breadcrumb_for @sales_return, 'new_sales_return_sales_return_entry_url' + "(#{@sales_return.id})", 
                "#{@sales_return.code}"
  end
end
