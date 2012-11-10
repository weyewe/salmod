class CreateStockAdditions < ActiveRecord::Migration
  def change
    create_table :stock_additions do |t|
      t.integer :source_document_id 
      t.integer :addition_case, :default => STOCK_ADDITION_CASE[:initial_migration]
      
      t.integer :quantity 
      
      t.integer :item_id
      

      t.timestamps
    end
  end
end


=begin
  case : purchase order 
  source_document_id => purchase_order.id 
  addition_case => STOCK_ADDITION_CASE[:purchase]
  
  quantity == quantity stated in purcahase order 
  
  # price? price stated in purchase order 
  # => purchase order entry? self.source_document.price 
  
  # entry case: addition or deduction
  
=end