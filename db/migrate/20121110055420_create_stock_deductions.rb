class CreateStockDeductions < ActiveRecord::Migration
  def change
    create_table :stock_deductions do |t|
      t.integer :quantity 
      t.integer :stock_entry_id 
      
      t.integer :creator_id  
      t.integer :source_document_id
      
      t.string  :source_document_entry 
      t.integer :source_document_entry_id
      
      t.string :source_document
      t.integer :source_document_id   
      
      t.integer :deduction_case  
      t.timestamps
    end
  end
end
