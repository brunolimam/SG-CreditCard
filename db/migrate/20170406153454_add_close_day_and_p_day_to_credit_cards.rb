class AddCloseDayAndPDayToCreditCards < ActiveRecord::Migration
  def change
    add_column :credit_cards, :close_day, :integer
    add_column :credit_cards, :p_day, :integer
  end
end
