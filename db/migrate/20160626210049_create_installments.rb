class CreateInstallments < ActiveRecord::Migration
  def change
    create_table :installments do |t|
      t.datetime :day_for_pay
      t.float :value
      t.belongs_to :person

      t.timestamps null: false
    end
  end
end
