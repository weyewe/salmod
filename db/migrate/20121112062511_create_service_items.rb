class CreateServiceItems < ActiveRecord::Migration
  def change
    create_table :service_items do |t|
      t.integer :service_id 
      t.integer :sales_entry_id
      # the price info is in the member 
      
      t.boolean :is_deleted, :default => false 
      
      t.boolean :is_confirmed, :default => false 

      t.timestamps
    end
  end
end
