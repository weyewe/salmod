class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :contact_person
      
      t.string :phone 
      t.string :mobile 
      t.string :email 
      t.string :bbm_pin  
      
      t.text :address 
       

      t.timestamps
    end
  end
end
