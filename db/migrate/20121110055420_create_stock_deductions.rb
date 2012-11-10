class CreateStockDeductions < ActiveRecord::Migration
  def change
    create_table :stock_deductions do |t|

      t.timestamps
    end
  end
end
