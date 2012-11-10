class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      # item has several phases: ready to be sold
      # scrap : broken, can't be returned to supplier 
      # pending_return : can be returned to supplier. but not yet delivered 
      
      t.integer :ready 
      t.integer :scrap 
      t.integer :pending_return

      t.string :name 
      
      t.integer :category_id 
      
      
      t.timestamps
    end
  end
end
