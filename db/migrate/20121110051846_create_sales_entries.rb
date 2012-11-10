class CreateSalesEntries < ActiveRecord::Migration
  def change
    create_table :sales_entries do |t|
      t.integer :stock_entry_id  # if it is product, the real price of that product is decided over here 
      # hence, we can calculate the net trading profit 
      # selling price 
      t.integer :entry_id 
      t.integer :entry_case , :default => SALES_ENTRY_CASE[:item]
      
      t.integer :quantity # only per piece # if service, it is 1 by default 
      
      t.integer :maintenance_id  # sales_entry can belong to maintenance (more specific)
      
      t.decimal :selling_price_per_piece , :precision => 11, :scale => 2 , :default => 0  # 10^9 << max value
      t.decimal :total_sales_price , :precision => 11, :scale => 2 , :default => 0  # 10^9 << max value

      t.timestamps
    end
  end
end
