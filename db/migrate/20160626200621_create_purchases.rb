class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.datetime :purchased_in

      t.timestamps null: false
    end
  end
end
