class AddDescribeToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :describe, :text
  end
end
