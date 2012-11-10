class CreateStockEntries < ActiveRecord::Migration
  def change
    create_table :stock_entries do |t|
      # stock entry can be: addition or deduction 
      t.integer :is_addition, :default => true  
      
      t.integer :source_document_id  
      t.string :source_document   
      t.integer :entry_case, :default => STOCK_ENTRY_CASE[:initial_migration]
      
      
      t.integer :quantity  
      t.integer :broken 
      t.integer :sold 
       
      t.integer :item_id
      
      t.decimal :base_price_per_piece, :precision => 12, :scale => 2 , :default => 0 # 10^9 << max value
       
      t.timestamps
    end
  end
end
