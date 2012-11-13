class StockMigrationsController < ApplicationController
  def new
    @new_object = StockMigration.new 
  end
  
  # only the view 
  def generate_stock_migration
    @new_object = StockEntry.new 
    @item_id =  params[:selected_item_id] 
    @item = Item.find_by_id @item_id
  end
  
  def create 
    item = Item.find_by_id params[:stock_migration][:item_id]  
    quantity = params[:stock_migration][:quantity]
    price_per_item = params[:stock_migration][:price_per_item]
    
    # @object = StockMigration.create_item_migration(current_user , item, params[:stock_migration])
    @object =   StockMigration.create_item_migration(admin, item, quantity,  price_per_item)  
    
    if @object.valid?
      @new_object=  StockMigration.new 
    else
      @new_object= @object
    end 
  end
  
  
  
end
