class CreateScrapItems < ActiveRecord::Migration
  def change
    create_table :scrap_items do |t|
      t.integer :creator_id 
      
      t.string :code
      t.integer :item_id 
      t.integer :quantity 

      t.timestamps
    end
  end
end
