class CreateReplaceItems < ActiveRecord::Migration
  def change
    create_table :replace_items do |t|

      t.timestamps
    end
  end
end
