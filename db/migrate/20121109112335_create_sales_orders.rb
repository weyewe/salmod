class CreateSalesOrders < ActiveRecord::Migration
  def change
    create_table :sales_orders do |t|
      
      t.string :code # sales order code  # year/month/ number 
      t.integer :creator_id 
      
      
      
      # for the indexing.. we might not need this for now
      # t.integer :year 
      # t.integer :month 
      # t.integer :yday 
      t.boolean :is_deleted , :default => false
      t.timestamps
    end
  end
end
