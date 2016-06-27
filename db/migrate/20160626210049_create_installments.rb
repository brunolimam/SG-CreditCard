class CreateInstallments < ActiveRecord::Migration
  def change
    create_table :installments do |t|
      t.datetime :p_day
      t.float :value
      t.belongs_to :purchase
      t.belongs_to :person

      t.timestamps null: false
    end
  end
end
