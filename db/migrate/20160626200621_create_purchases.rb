class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.datetime :purchased_in
      t.integer :quantity_installments
      t.string :place_name
      t.float :value

      t.timestamps null: false
    end
  end
end
