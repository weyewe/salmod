class CreateStockMutations < ActiveRecord::Migration
  def change
    create_table :stock_mutations do |t|
      t.integer :quantity 
      t.integer :stock_entry_id 
      
      t.integer :creator_id  
      t.integer :source_document_id
      
      t.string  :source_document_entry 
      t.integer :source_document_entry_id
      
      t.string :source_document
      t.integer :source_document_id   
      
      t.integer :mutation_case 
      
      t.integer :mutation_status, :default => MUTATION_STATUS[:deduction] 
      
      t.integer :item_status, :default => ITEM_STATUS[:ready]
      t.integer :item_id 
      t.timestamps
    end
  end
end
