class FixPDayFromInstallments < ActiveRecord::Migration
  def change
    FixPDayFromInstallments.up
  end

  def self.up
    Installment.all.each do |installment|
      date = installment.p_day
      date = (date+1.month).change({ day: installment.purchase.credit_card.p_day })

      installment.update(p_day: date)
    end
  end
end
