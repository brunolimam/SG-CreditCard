class AddCreditCardToPurchases < ActiveRecord::Migration
  def change
    add_reference :purchases, :credit_card, index: true, foreign_key: true
  end
end
