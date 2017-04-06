class UpdatePurchases < ActiveRecord::Migration
  def change
  	cc = CreditCard.create(display_number: "4721", limit: 15000)
  	Purchase.update_all(credit_card_id: cc.id)
  	puts "Compras atualizadas"
  end
end
