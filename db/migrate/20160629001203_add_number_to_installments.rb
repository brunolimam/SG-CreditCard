class AddNumberToInstallments < ActiveRecord::Migration
  def change
    add_column :installments, :number, :integer

    AddNumberToInstallments.up
  end

  def self.up

    Person.all.each do |person|
      last_purchase = nil
      index = 1

      person.installments.each do |installment|
        index = 1 if last_purchase != installment.purchase

        installment.update(number: index)

        index+=1
        last_purchase = installment.purchase
      end

    end

    # Purchase.all.each do |purchase|
    #   puts "Updating #{purchase.place_name}"
    #   purchase.installments.order(p_day: :asc).each_with_index do |installment, index|
    #     installment.update(number: index+1)
    #   end
    # end

  end
end
