class StockMutation < ActiveRecord::Base
  attr_accessible :quantity, :stock_entry_id, :source_document_entry_id, 
                  :creator_id, :source_document_id, :source_document_entry,
                  :source_document, :deduction_case,
                  :mutation_case, :mutation_status,
                  :item_id

  belongs_to :stock_entry 
  belongs_to :item 
end
