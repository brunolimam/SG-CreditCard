class AddFixedToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :fixed, :boolean
  end
end
