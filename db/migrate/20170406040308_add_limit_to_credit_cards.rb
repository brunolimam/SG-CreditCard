class AddLimitToCreditCards < ActiveRecord::Migration
  def change
    add_column :credit_cards, :limit, :integer
  end
end
