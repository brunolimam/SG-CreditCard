class AddFinancialToCreditCard < ActiveRecord::Migration
  def change
    add_column :credit_cards, :financial, :integer
  end
end
